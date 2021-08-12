unit AWS.SNS.Model.CreateTopicRequest;

interface

uses
  System.Generics.Collections, 
  Bcl.Types.Nullable, 
  AWS.SNS.Model.Request, 
  AWS.SNS.Model.Tag;

type
  TCreateTopicRequest = class;
  
  ICreateTopicRequest = interface
    function GetAttributes: TDictionary<string, string>;
    procedure SetAttributes(const Value: TDictionary<string, string>);
    function GetName: string;
    procedure SetName(const Value: string);
    function GetTags: TObjectList<TTag>;
    procedure SetTags(const Value: TObjectList<TTag>);
    function Obj: TCreateTopicRequest;
    function IsSetAttributes: Boolean;
    function IsSetName: Boolean;
    function IsSetTags: Boolean;
    property Attributes: TDictionary<string, string> read GetAttributes write SetAttributes;
    property Name: string read GetName write SetName;
    property Tags: TObjectList<TTag> read GetTags write SetTags;
  end;
  
  TCreateTopicRequest = class(TAmazonSimpleNotificationServiceRequest, ICreateTopicRequest)
  strict private
    FAttributes: TDictionary<string, string>;
    FName: Nullable<string>;
    FTags: TObjectList<TTag>;
    function GetAttributes: TDictionary<string, string>;
    procedure SetAttributes(const Value: TDictionary<string, string>);
    function GetName: string;
    procedure SetName(const Value: string);
    function GetTags: TObjectList<TTag>;
    procedure SetTags(const Value: TObjectList<TTag>);
  strict protected
    function Obj: TCreateTopicRequest;
  public
    constructor Create; overload;
    destructor Destroy; override;
    constructor Create(const AName: string); overload;
    function IsSetAttributes: Boolean;
    function IsSetName: Boolean;
    function IsSetTags: Boolean;
    property Attributes: TDictionary<string, string> read GetAttributes write SetAttributes;
    property Name: string read GetName write SetName;
    property Tags: TObjectList<TTag> read GetTags write SetTags;
  end;
  
implementation

{ TCreateTopicRequest }

constructor TCreateTopicRequest.Create;
begin
  inherited;
  FAttributes := TDictionary<string, string>.Create;
  FTags := TObjectList<TTag>.Create;
end;

destructor TCreateTopicRequest.Destroy;
begin
  FTags.Free;
  FAttributes.Free;
  inherited;
end;

function TCreateTopicRequest.Obj: TCreateTopicRequest;
begin
  Result := Self;
end;

constructor TCreateTopicRequest.Create(const AName: string);
begin
  inherited Create;
  Name := AName;
end;

function TCreateTopicRequest.GetAttributes: TDictionary<string, string>;
begin
  Result := FAttributes;
end;

procedure TCreateTopicRequest.SetAttributes(const Value: TDictionary<string, string>);
begin
  if FAttributes <> Value then
  begin
    FAttributes.Free;
    FAttributes := Value;
  end;
end;

function TCreateTopicRequest.IsSetAttributes: Boolean;
begin
  Result := (FAttributes <> nil) and (FAttributes.Count > 0);
end;

function TCreateTopicRequest.GetName: string;
begin
  Result := FName.ValueOrDefault;
end;

procedure TCreateTopicRequest.SetName(const Value: string);
begin
  FName := Value;
end;

function TCreateTopicRequest.IsSetName: Boolean;
begin
  Result := FName.HasValue;
end;

function TCreateTopicRequest.GetTags: TObjectList<TTag>;
begin
  Result := FTags;
end;

procedure TCreateTopicRequest.SetTags(const Value: TObjectList<TTag>);
begin
  if FTags <> Value then
  begin
    FTags.Free;
    FTags := Value;
  end;
end;

function TCreateTopicRequest.IsSetTags: Boolean;
begin
  Result := (FTags <> nil) and (FTags.Count > 0);
end;

end.