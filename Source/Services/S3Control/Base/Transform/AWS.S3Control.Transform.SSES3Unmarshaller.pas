unit AWS.S3Control.Transform.SSES3Unmarshaller;

interface

uses
  AWS.S3Control.Model.SSES3, 
  AWS.Transform.UnmarshallerContext, 
  AWS.Transform.ResponseUnmarshaller, 
  AWS.Internal.Request;

type
  ISSES3Unmarshaller = IUnmarshaller<TSSES3, TXmlUnmarshallerContext>;
  
  TSSES3Unmarshaller = class(TInterfacedObject, IUnmarshaller<TSSES3, TXmlUnmarshallerContext>)
  strict private
    class var FInstance: ISSES3Unmarshaller;
    class constructor Create;
  public
    function Unmarshall(AContext: TXmlUnmarshallerContext): TSSES3;
    class function Instance: ISSES3Unmarshaller; static;
  end;
  
implementation

{ TSSES3Unmarshaller }

function TSSES3Unmarshaller.Unmarshall(AContext: TXmlUnmarshallerContext): TSSES3;
var
  OriginalDepth: Integer;
  TargetDepth: Integer;
  UnmarshalledObject: TSSES3;
begin
  UnmarshalledObject := TSSES3.Create;
  try
    OriginalDepth := AContext.CurrentDepth;
    TargetDepth := OriginalDepth + 1;
    if AContext.IsStartOfDocument then
      Inc(TargetDepth, 2);
    while AContext.Read do
      if AContext.IsStartElement or AContext.IsAttribute then
      begin
      end
      else
        if AContext.IsEndElement and (AContext.CurrentDepth < OriginalDepth) then
          Exit(UnmarshalledObject);
    Result := UnmarshalledObject;
    UnmarshalledObject := nil;
  finally
    UnmarshalledObject.Free;
  end;
end;

class constructor TSSES3Unmarshaller.Create;
begin
  FInstance := TSSES3Unmarshaller.Create;
end;

class function TSSES3Unmarshaller.Instance: ISSES3Unmarshaller;
begin
  Result := FInstance;
end;

end.