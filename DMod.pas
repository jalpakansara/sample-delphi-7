unit DMod;

interface

uses
  SysUtils, Classes, ADODB, DB, Controls;

type
  TDM = class(TDataModule)
    ADOConnection1: TADOConnection;
    qPolicies: TADOQuery;
    qPayments: TADOQuery;
    dsPolicies: TDataSource;
    dsPayments: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConfigureConnection(const AConnStr: string);
    procedure OpenPolicyData(const PolicyNo: string);
    procedure CloseAll;
    function BeginTransaction: Integer;
    procedure CommitTransaction(TransID: Integer);
    procedure RollbackTransaction(TransID: Integer);
  end;

var
  DM: TDM;

implementation

{ *.dfm}

{ TDM }

procedure TDM.ConfigureConnection(const AConnStr: string);
begin
  ADOConnection1.Close;
  ADOConnection1.ConnectionString := AConnStr;
  ADOConnection1.LoginPrompt := False;
  // Do not automatically connect here; callers decide
end;

procedure TDM.OpenPolicyData(const PolicyNo: string);
begin
  // close first
  CloseAll;
  // Example: qPolicies uses a parameter :PolicyNo and qPayments uses :PolicyNo
  qPolicies.Parameters.ParamByName('PolicyNo').Value := PolicyNo;
  qPayments.Parameters.ParamByName('PolicyNo').Value := PolicyNo;

  qPolicies.Open;
  qPayments.Open;
end;

procedure TDM.CloseAll;
begin
  if qPayments.Active then qPayments.Close;
  if qPolicies.Active then qPolicies.Close;
end;

function TDM.BeginTransaction: Integer;
begin
  // ADOConnection.BeginTrans returns a long integer transaction handle
  Result := ADOConnection1.BeginTrans;
end;

procedure TDM.CommitTransaction(TransID: Integer);
begin
  // ADO commit doesn't require the handle, but we keep the pattern
  ADOConnection1.CommitTrans;
end;

procedure TDM.RollbackTransaction(TransID: Integer);
begin
  ADOConnection1.RollbackTrans;
end;

end.
