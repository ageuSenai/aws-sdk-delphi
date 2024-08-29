unit AWS.SSM.Transform.DescribeInventoryDeletionsRequestMarshaller;

interface

uses
  System.Classes, 
  System.SysUtils, 
  AWS.Internal.Request, 
  AWS.Transform.RequestMarshaller, 
  AWS.Runtime.Model, 
  AWS.SSM.Model.DescribeInventoryDeletionsRequest, 
  AWS.Internal.DefaultRequest, 
  AWS.SDKUtils, 
  AWS.Json.Writer;

type
  IDescribeInventoryDeletionsRequestMarshaller = IMarshaller<IRequest, TAmazonWebServiceRequest>;
  
  TDescribeInventoryDeletionsRequestMarshaller = class(TInterfacedObject, IMarshaller<IRequest, TDescribeInventoryDeletionsRequest>, IDescribeInventoryDeletionsRequestMarshaller)
  strict private
    class var FInstance: IDescribeInventoryDeletionsRequestMarshaller;
    class constructor Create;
  public
    function Marshall(AInput: TAmazonWebServiceRequest): IRequest; overload;
    function Marshall(PublicRequest: TDescribeInventoryDeletionsRequest): IRequest; overload;
    class function Instance: IDescribeInventoryDeletionsRequestMarshaller; static;
  end;
  
implementation

{ TDescribeInventoryDeletionsRequestMarshaller }

function TDescribeInventoryDeletionsRequestMarshaller.Marshall(AInput: TAmazonWebServiceRequest): IRequest;
begin
  Result := Marshall(TDescribeInventoryDeletionsRequest(AInput));
end;

function TDescribeInventoryDeletionsRequestMarshaller.Marshall(PublicRequest: TDescribeInventoryDeletionsRequest): IRequest;
var
  Request: IRequest;
begin
  Request := TDefaultRequest.Create(PublicRequest, 'Amazon.SimpleSystemsManagement');
  Request.Headers.Add('X-Amz-Target', 'AmazonSSM.DescribeInventoryDeletions');
  Request.Headers.AddOrSetValue('Content-Type', 'application/x-amz-json-1.1');
  Request.Headers.AddOrSetValue(THeaderKeys.XAmzApiVersion, '2014-11-06');
  Request.HttpMethod := 'POST';
  Request.ResourcePath := '/';
  var Stream: TStringStream := TStringStream.Create('', TEncoding.UTF8, False);
  try
    var Writer: TJsonWriter := TJsonWriter.Create(Stream);
    try
      var Context: TJsonMarshallerContext := TJsonMarshallerContext.Create(Request, Writer);
      try
        Writer.WriteBeginObject;
        if PublicRequest.IsSetDeletionId then
        begin
          Context.Writer.WriteName('DeletionId');
          Context.Writer.WriteString(PublicRequest.DeletionId);
        end;
        if PublicRequest.IsSetMaxResults then
        begin
          Context.Writer.WriteName('MaxResults');
          Context.Writer.WriteInteger(PublicRequest.MaxResults);
        end;
        if PublicRequest.IsSetNextToken then
        begin
          Context.Writer.WriteName('NextToken');
          Context.Writer.WriteString(PublicRequest.NextToken);
        end;
        Writer.WriteEndObject;
        Writer.Flush;
        var Snippet: string := Stream.DataString;
        Request.Content := TEncoding.UTF8.GetBytes(Snippet);
      finally
        Context.Free;
      end;
    finally
      Writer.Free;
    end;
  finally
    Stream.Free;
  end;
  Result := Request;
end;

class constructor TDescribeInventoryDeletionsRequestMarshaller.Create;
begin
  FInstance := TDescribeInventoryDeletionsRequestMarshaller.Create;
end;

class function TDescribeInventoryDeletionsRequestMarshaller.Instance: IDescribeInventoryDeletionsRequestMarshaller;
begin
  Result := FInstance;
end;

end.