unit AWS.Rekognition.Transform.DeleteStreamProcessorResponseUnmarshaller;

interface

uses
  AWS.Rekognition.Model.DeleteStreamProcessorResponse, 
  AWS.Transform.ResponseUnmarshaller, 
  AWS.Runtime.Model, 
  AWS.Transform.JsonUnmarshallerContext, 
  AWS.Runtime.Exceptions, 
  System.SysUtils, 
  AWS.Internal.ErrorResponse, 
  AWS.Transform.JsonErrorResponseUnmarshaller, 
  System.Classes, 
  AWS.Rekognition.Transform.AccessDeniedExceptionUnmarshaller, 
  AWS.Rekognition.Transform.InternalServerErrorExceptionUnmarshaller, 
  AWS.Rekognition.Transform.InvalidParameterExceptionUnmarshaller, 
  AWS.Rekognition.Transform.ProvisionedThroughputExceededExceptionUnmarshaller, 
  AWS.Rekognition.Transform.ResourceInUseExceptionUnmarshaller, 
  AWS.Rekognition.Transform.ResourceNotFoundExceptionUnmarshaller, 
  AWS.Rekognition.Transform.ThrottlingExceptionUnmarshaller, 
  AWS.Rekognition.Exception;

type
  IDeleteStreamProcessorResponseUnmarshaller = IResponseUnmarshaller;
  
  TDeleteStreamProcessorResponseUnmarshaller = class(TJsonResponseUnmarshaller, IDeleteStreamProcessorResponseUnmarshaller)
  strict private
    class var FInstance: IDeleteStreamProcessorResponseUnmarshaller;
    class constructor Create;
  public
    function Unmarshall(AContext: TJsonUnmarshallerContext): TAmazonWebServiceResponse; overload; override;
    function UnmarshallException(AContext: TJsonUnmarshallerContext; AInnerException: Exception; AStatusCode: Integer): EAmazonServiceException; override;
    class function Instance: IDeleteStreamProcessorResponseUnmarshaller; static;
  end;
  
implementation

{ TDeleteStreamProcessorResponseUnmarshaller }

function TDeleteStreamProcessorResponseUnmarshaller.Unmarshall(AContext: TJsonUnmarshallerContext): TAmazonWebServiceResponse;
var
  Response: TDeleteStreamProcessorResponse;
begin
  Response := TDeleteStreamProcessorResponse.Create;
  try
    Result := Response;
    Response := nil;
  finally
    Response.Free;
  end;
end;

function TDeleteStreamProcessorResponseUnmarshaller.UnmarshallException(AContext: TJsonUnmarshallerContext; AInnerException: Exception; AStatusCode: Integer): EAmazonServiceException;
var
  ErrorResponse: TErrorResponse;
  StreamCopy: TStream;
  ContextCopy: TJsonUnmarshallerContext;
begin
  ErrorResponse := TJsonErrorResponseUnmarshaller.Instance.Unmarshall(AContext);
  try
    ErrorResponse.InnerException := AInnerException;
    ErrorResponse.StatusCode := AStatusCode;
    StreamCopy := TBytesStream.Create(AContext.GetResponseBodyBytes);
    try
      ContextCopy := TJsonUnmarshallerContext.Create(StreamCopy, False, nil);
      try
        if ErrorResponse.Code = 'AccessDeniedException' then
          Exit(TAccessDeniedExceptionUnmarshaller.Instance.Unmarshall(ContextCopy, ErrorResponse));
        if ErrorResponse.Code = 'InternalServerErrorException' then
          Exit(TInternalServerErrorExceptionUnmarshaller.Instance.Unmarshall(ContextCopy, ErrorResponse));
        if ErrorResponse.Code = 'InvalidParameterException' then
          Exit(TInvalidParameterExceptionUnmarshaller.Instance.Unmarshall(ContextCopy, ErrorResponse));
        if ErrorResponse.Code = 'ProvisionedThroughputExceededException' then
          Exit(TProvisionedThroughputExceededExceptionUnmarshaller.Instance.Unmarshall(ContextCopy, ErrorResponse));
        if ErrorResponse.Code = 'ResourceInUseException' then
          Exit(TResourceInUseExceptionUnmarshaller.Instance.Unmarshall(ContextCopy, ErrorResponse));
        if ErrorResponse.Code = 'ResourceNotFoundException' then
          Exit(TResourceNotFoundExceptionUnmarshaller.Instance.Unmarshall(ContextCopy, ErrorResponse));
        if ErrorResponse.Code = 'ThrottlingException' then
          Exit(TThrottlingExceptionUnmarshaller.Instance.Unmarshall(ContextCopy, ErrorResponse));
      finally
        ContextCopy.Free;
      end;
    finally
      StreamCopy.Free;
    end;
    Exit(EAmazonRekognitionException.Create(ErrorResponse.Message, AInnerException, ErrorResponse.ErrorType, ErrorResponse.Code, ErrorResponse.RequestId, AStatusCode));
  finally
    ErrorResponse.Free;
  end;
end;

class constructor TDeleteStreamProcessorResponseUnmarshaller.Create;
begin
  FInstance := TDeleteStreamProcessorResponseUnmarshaller.Create;
end;

class function TDeleteStreamProcessorResponseUnmarshaller.Instance: IDeleteStreamProcessorResponseUnmarshaller;
begin
  Result := FInstance;
end;

end.
