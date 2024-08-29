unit AWS.SSM.Transform.DescribeParametersRequestMarshaller;

interface

uses
  System.Classes, 
  System.SysUtils, 
  AWS.Internal.Request, 
  AWS.Transform.RequestMarshaller, 
  AWS.Runtime.Model, 
  AWS.SSM.Model.DescribeParametersRequest, 
  AWS.Internal.DefaultRequest, 
  AWS.SDKUtils, 
  AWS.Json.Writer, 
  AWS.SSM.Transform.ParametersFilterMarshaller, 
  AWS.SSM.Transform.ParameterStringFilterMarshaller;

type
  IDescribeParametersRequestMarshaller = IMarshaller<IRequest, TAmazonWebServiceRequest>;
  
  TDescribeParametersRequestMarshaller = class(TInterfacedObject, IMarshaller<IRequest, TDescribeParametersRequest>, IDescribeParametersRequestMarshaller)
  strict private
    class var FInstance: IDescribeParametersRequestMarshaller;
    class constructor Create;
  public
    function Marshall(AInput: TAmazonWebServiceRequest): IRequest; overload;
    function Marshall(PublicRequest: TDescribeParametersRequest): IRequest; overload;
    class function Instance: IDescribeParametersRequestMarshaller; static;
  end;
  
implementation

{ TDescribeParametersRequestMarshaller }

function TDescribeParametersRequestMarshaller.Marshall(AInput: TAmazonWebServiceRequest): IRequest;
begin
  Result := Marshall(TDescribeParametersRequest(AInput));
end;

function TDescribeParametersRequestMarshaller.Marshall(PublicRequest: TDescribeParametersRequest): IRequest;
var
  Request: IRequest;
begin
  Request := TDefaultRequest.Create(PublicRequest, 'Amazon.SimpleSystemsManagement');
  Request.Headers.Add('X-Amz-Target', 'AmazonSSM.DescribeParameters');
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
        if PublicRequest.IsSetFilters then
        begin
          Context.Writer.WriteName('Filters');
          Context.Writer.WriteBeginArray;
          for var PublicRequestFiltersListValue in PublicRequest.Filters do
          begin
            Context.Writer.WriteBeginObject;
            TParametersFilterMarshaller.Instance.Marshall(PublicRequestFiltersListValue, Context);
            Context.Writer.WriteEndObject;
          end;
          Context.Writer.WriteEndArray;
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
        if PublicRequest.IsSetParameterFilters then
        begin
          Context.Writer.WriteName('ParameterFilters');
          Context.Writer.WriteBeginArray;
          for var PublicRequestParameterFiltersListValue in PublicRequest.ParameterFilters do
          begin
            Context.Writer.WriteBeginObject;
            TParameterStringFilterMarshaller.Instance.Marshall(PublicRequestParameterFiltersListValue, Context);
            Context.Writer.WriteEndObject;
          end;
          Context.Writer.WriteEndArray;
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

class constructor TDescribeParametersRequestMarshaller.Create;
begin
  FInstance := TDescribeParametersRequestMarshaller.Create;
end;

class function TDescribeParametersRequestMarshaller.Instance: IDescribeParametersRequestMarshaller;
begin
  Result := FInstance;
end;

end.