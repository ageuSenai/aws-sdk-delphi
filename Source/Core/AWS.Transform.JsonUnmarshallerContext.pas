unit AWS.Transform.JsonUnmarshallerContext;

{$I AWS.inc}

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.TypInfo,
  Bcl.Json.Reader,
  Bcl.Types.Nullable,
  AWS.Transform.UnmarshallerContext,
  AWS.Internal.WebResponseData;

type
  TPathSegmentType = (Value, Delimiter);

  TPathSegment = record
    SegmentType: TPathSegmentType;
    Value: string;
    constructor Create(ASegmentType: TPathSegmentType; const AValue: string);
  end;

  TJsonPathStack = class
  strict private
    FStack: TStack<TPathSegment>;
    FCurrentDepth: Integer;
    FStackStringBuilder: TStringBuilder;
    FStackString: string;
  protected
    procedure Push(ASegment: TPathSegment);
    function Pop: TPathSegment;
    function Peek: TPathSegment;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    function CurrentPath: string;
    property CurrentDepth: Integer read FCurrentDepth;
  end;

  TJsonUnmarshallerContext = class(TUnmarshallerContext)
  strict private
    const DELIMITER = '/';
  strict private
    FStream: TStream;
    FJsonReader: TJsonReader;
    FStack: TJsonPathStack;
    FCurrentText: Nullable<string>;
    FCurrentToken: Nullable<TJsonToken>;
    FWasPeeked: Boolean;
    FReadCalled: Boolean;
    procedure UpdateContext;
  public
    constructor Create(AResponseStream: TStream; AMaintainResponseBody: Boolean;
      AResponseData: IWebResponseData; AIsException: Boolean = false); reintroduce;
    destructor Destroy; override;
    function CurrentPath: string; override;
    function CurrentDepth: Integer; override;
    function Read: Boolean; override;
    function ReadText: string; override;
    function IsStartElement: Boolean; override;
    function IsEndElement: Boolean; override;
    function IsStartOfDocument: Boolean; override;
    function Peek(AToken: TJsonToken): Boolean; overload;
    property Stream: TStream read FStream;
  end;

implementation

uses
  AWS.Configs,
  AWS.Util.Streams,
  AWS.Runtime.Exceptions;

{ TPathSegment }

constructor TPathSegment.Create(ASegmentType: TPathSegmentType; const AValue: string);
begin
  SegmentType := ASegmentType;
  Value := AValue;
end;

{ TJsonPathStack }

function TJsonPathStack.Count: Integer;
begin
  Result := FStack.Count;
end;

constructor TJsonPathStack.Create;
begin
  inherited Create;
  FStackStringBuilder := TStringBuilder.Create(128);
  FStack := TStack<TPathSegment>.Create;
end;

function TJsonPathStack.CurrentPath: string;
begin
  if FStackString = '' then
    FStackString := FStackStringBuilder.ToString;
  Result := FStackString;
end;

destructor TJsonPathStack.Destroy;
begin
  FStack.Free;
  FStackStringBuilder.Free;
  inherited;
end;

function TJsonPathStack.Peek: TPathSegment;
begin
  Result := FStack.Peek;
end;

function TJsonPathStack.Pop: TPathSegment;
var
  Segment: TPathSegment;
begin
  Segment := FStack.Pop;
  if Segment.SegmentType = TPathSegmentType.Delimiter then
    Dec(FCurrentDepth);
  FStackStringBuilder.Remove(FStackStringBuilder.Length - Length(Segment.Value), Length(Segment.Value));
  FStackString := '';
  Result := Segment;
end;

procedure TJsonPathStack.Push(ASegment: TPathSegment);
begin
  if ASegment.SegmentType = TPathSegmentType.Delimiter then
    Inc(FCurrentDepth);
  FStackStringBuilder.Append(ASegment.Value);
  FStackString := '';
  FStack.Push(ASegment);
end;

{ TJsonUnmarshallerContext }

constructor TJsonUnmarshallerContext.Create(AResponseStream: TStream; AMaintainResponseBody: Boolean;
  AResponseData: IWebResponseData; AIsException: Boolean);
var
  SizeLimit: Integer;
begin
  inherited Create;
  SizeLimit := TAWSConfigs.LoggingConfig.LogResponsesSizeLimit;
  if IsException then
    SetWrappingStream(TCachingWrapperStream.Create(AResponseStream, False, SizeLimit, MaxInt))
  else
  if AMaintainResponseBody then
    SetWrappingStream(TCachingWrapperStream.Create(AResponseStream, False, SizeLimit, SizeLimit));

  if IsException or AMaintainResponseBody then
    AResponseStream := WrappingStream;

  FStream := AResponseStream;
  WebResponseData := AResponseData;
  MaintainResponseBody := AMaintainResponseBody;
  IsException := AIsException;
  FJsonReader := TJsonReader.Create(FStream);
end;

function TJsonUnmarshallerContext.CurrentDepth: Integer;
begin
  Result := FStack.CurrentDepth;
end;

function TJsonUnmarshallerContext.CurrentPath: string;
begin
  Result := FStack.CurrentPath;
end;

destructor TJsonUnmarshallerContext.Destroy;
begin
  FJsonReader.Free;
  inherited;
end;

function TJsonUnmarshallerContext.IsEndElement: Boolean;
begin
  Result := FCurrentToken = TJsonToken.EndObject;
end;

function TJsonUnmarshallerContext.IsStartElement: Boolean;
begin
  Result := FCurrentToken = TJsonToken.BeginObject;
end;

function TJsonUnmarshallerContext.IsStartOfDocument: Boolean;
begin
  Result := not FReadCalled;
end;

function TJsonUnmarshallerContext.Peek(AToken: TJsonToken): Boolean;
begin
  if FWasPeeked then
    Exit(not FCurrentToken.IsNull and (FCurrentToken = AToken));

  if Read then
  begin
    FWasPeeked := True;
    Exit(FCurrentToken = AToken);
  end;
  Result := False;
end;

function TJsonUnmarshallerContext.Read: Boolean;
begin
  if FWasPeeked then
  begin
    FWasPeeked := False;
    Exit(FCurrentToken.IsNull);
  end;

  if not FReadCalled then
    FReadCalled := True;
  FCurrentToken := FJsonReader.Peek;
  if not FJsonReader.Eof then
    UpdateContext
  else
  begin
    FCurrentToken := SNull;
    FCurrentText := SNull;
  end;
  FWasPeeked := False;
  Result := FCurrentToken <> TJsonToken.EOF;
end;

function TJsonUnmarshallerContext.ReadText: string;
begin
  if FCurrentText.HasValue then
    Result := FCurrentText.Value
  else
    raise EAmazonClientException.CreateFmt('We expected a VALUE token but got: %s',
      [GetEnumName(TypeInfo(TJsonToken), Ord(FCurrentToken.Value))]);
end;

procedure TJsonUnmarshallerContext.UpdateContext;
begin
  if not FCurrentToken.HasValue then Exit;

  FCurrentText := SNull;
  if (FCurrentToken.Value = TJsonToken.BeginObject) or (FCurrentToken.Value = TJsonToken.BeginArray) then
  begin
    FStack.Push(TPathSegment.Create(TPathSegmentType.Delimiter, DELIMITER));
    FJsonReader.SkipValue;
  end
  else
  if (FCurrentToken.Value = TJsonToken.EndObject) or (FCurrentToken.Value = TJsonToken.EndArray) then
  begin
    if FStack.Peek.SegmentType = TPathSegmentType.Delimiter then
    begin
      // Pop '/' associated with corresponding object start and array start.
      FStack.Pop;
      if (FStack.Count > 0) and (FStack.Peek.SegmentType <> TPathSegmentType.Delimiter) then
        // Pop the property name associated with the
        // object or array if present.
        // e.g. {"a":["1","2","3"]}
        FStack.Pop;
    end;
    FJsonReader.SkipValue;
  end
  else
  if (FCurrentToken.Value = TJsonToken.Name) then
  begin
    FCurrentText := FJsonReader.ReadName;
    FStack.Push(TPathSegment.Create(TPathSegmentType.Value, FCurrentText))
  end
  else
  if FCurrentToken.Value <> TJsonToken.EOF then
  begin
    if FStack.Peek.SegmentType <> TPathSegmentType.Delimiter then
    // Pop if you encounter a simple data type or null
    // This will pop the property name associated with it in cases like  {"a":"b"}.
    // Exclude the case where it's a value in an array so we dont end poping the start of array and
    // property name e.g. {"a":["1","2","3"]}
      FStack.Pop;

    case FCurrentToken.Value of
      TJsonToken.Boolean:
        if FJsonReader.ReadBoolean then
          FCurrentText := 'true'
        else
          FCurrentText := 'false';
      TJsonToken.Null:
        begin
          FCurrentText := '';
          FJsonReader.SkipValue;
        end
    else
      // TJsonToken.Text, TJsonToken.Number
      FCurrentText := FJsonReader.ReadString;
    end;
  end;
end;

end.