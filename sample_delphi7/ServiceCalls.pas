unit ServiceCalls;

interface

uses
  SysUtils, Classes, DateUtils, System.Net.HttpClient;

type
  TServiceResult = record
    Success: Boolean;
    Message: string;
  end;

function GetTaxRateForDate(ADate: TDateTime): Double;
function SendReportToService(const PolicyNo: string; const Summary: string): TServiceResult;
procedure LogSnippet(const S: string);

implementation

function GetTaxRateForDate(ADate: TDateTime): Double;
begin
  // Simple example: tax changes over time; stubbed logic
  if YearOf(ADate) < 2015 then
    Result := 0.10
  else if YearOf(ADate) < 2020 then
    Result := 0.12
  else
    Result := 0.15;
end;

function SendReportToService(const PolicyNo: string; const Summary: string): TServiceResult;
var
  Client: THTTPClient;
  Response: IHTTPResponse;
begin
  Client := THTTPClient.Create;
  try
    Response := Client.Post('https://your-api-endpoint.com/report',
      TStringStream.Create(Format('{"policy":"%s","summary":"%s"}', [PolicyNo, Summary]), TEncoding.UTF8),
      nil);
    Result.Success := Response.StatusCode = 200;
    Result.Message := Response.ContentAsString;
  finally
    Client.Free;
  end;
end;

procedure LogSnippet(const S: string);
begin
  // In real app log to file / event log. Here we simply output to console for demo.
  Writeln(Format('%s  - %s', [DateTimeToStr(Now), S]));
end;

end.
