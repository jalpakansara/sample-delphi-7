unit MainUnit;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, System.Net.HttpClient, System.Net.URLClient;

type
  TMainProcessor = class
  private
    ADOQuery: TADOQuery;
    HTTPClient: THTTPClient;
    function CalculateDiscount(Amount: Double): Double;
    function IsEligible(Amount: Double): Boolean;
    function FetchCustomerName(CustomerID: Integer): string;
    function CallExternalService(Data: string): string;
  public
    procedure Process(CustomerID: Integer; PurchaseAmount: Double);
  end;

implementation

function TMainProcessor.CalculateDiscount(Amount: Double): Double;
begin
  // Simple calculation
  Result := Amount * 0.1;
end;

function TMainProcessor.IsEligible(Amount: Double): Boolean;
begin
  // Decision node
  Result := Amount > 1000;
end;

function TMainProcessor.FetchCustomerName(CustomerID: Integer): string;
begin
  // DB call
  ADOQuery.SQL.Text := 'SELECT Name FROM Customers WHERE ID = :ID';
  ADOQuery.Parameters.ParamByName('ID').Value := CustomerID;
  ADOQuery.Open;
  Result := ADOQuery.FieldByName('Name').AsString;
  ADOQuery.Close;
end;

function TMainProcessor.CallExternalService(Data: string): string;
var
  Response: IHTTPResponse;
begin
  // Service call
  Response := HTTPClient.Post('https://api.example.com/process', TStringStream.Create(Data));
  Result := Response.ContentAsString;
end;

procedure TMainProcessor.Process(CustomerID: Integer; PurchaseAmount: Double);
var
  DiscountedAmount: Double;
  CustomerName, ServiceResponse: string;
begin
  CustomerName := FetchCustomerName(CustomerID);
  if IsEligible(PurchaseAmount) then
  begin
    DiscountedAmount := CalculateDiscount(PurchaseAmount);
    ServiceResponse := CallExternalService(Format('Customer=%s&Amount=%.2f', [CustomerName, DiscountedAmount]));
    Writeln('Service Response: ' + ServiceResponse);
  end
  else
    Writeln('Customer not eligible for discount.');
end;

end.
