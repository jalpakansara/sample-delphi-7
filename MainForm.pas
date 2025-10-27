unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls, ExtCtrls, DMod, ServiceCalls;

type
  TFrmMain = class(TForm)
    pnlTop: TPanel;
    lblPolicy: TLabel;
    edtPolicyNo: TEdit;
    btnLoad: TButton;
    btnExport: TButton;
    DBGridPolicies: TDBGrid;
    DBGridPayments: TDBGrid;
    lblTotalPayments: TLabel;
    lblDecision: TLabel;
    procedure btnLoadClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function ComputeTotals(out TotalAmount: Currency; out TotalTax: Currency): Integer;
    procedure DoBusinessRules(const PolicyNo: string; TotalAmount: Currency; TotalTax: Currency);
    procedure ShowMessageModal(const Text: string);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{ *.dfm}

uses
  DB, Math;

procedure TFrmMain.btnLoadClick(Sender: TObject);
var
  policyNo: string;
  total, totalTax: Currency;
  transID: Integer;
  ok: Boolean;
begin
  policyNo := Trim(edtPolicyNo.Text);
  if policyNo = '' then
  begin
    ShowMessageModal('Please enter a policy number.');
    Exit;
  end;

  try
    if not DM.ADOConnection1.Connected then
      DM.ADOConnection1.Connected := True;

    transID := DM.BeginTransaction;
    try
      DM.OpenPolicyData(policyNo);
      ok := (DM.qPolicies.RecordCount > 0);
      if not ok then
      begin
        DM.RollbackTransaction(transID);
        ShowMessageModal('Policy not found: ' + policyNo);
        Exit;
      end;

      ComputeTotals(total, totalTax);
      DoBusinessRules(policyNo, total, totalTax);
      DM.CommitTransaction(transID);
    except
      on E: Exception do
      begin
        DM.RollbackTransaction(transID);
        ShowMessageModal('Error while loading policy: ' + E.Message);
        Exit;
      end;
    end;

  except
    on E: Exception do
      ShowMessageModal('Database connection error: ' + E.Message);
  end;
end;

procedure TFrmMain.btnExportClick(Sender: TObject);
var
  summary: string;
  res: TServiceResult;
  total, totalTax: Currency;
begin
  if DM.qPolicies.Active then
  begin
    ComputeTotals(total, totalTax);
    summary := Format('Policy %s: Total=%m TotalTax=%m', [DM.qPolicies.FieldByName('PolicyNo').AsString, total, totalTax]);
    res := SendReportToService(DM.qPolicies.FieldByName('PolicyNo').AsString, summary);
    if res.Success then
      ShowMessageModal('Export successful: ' + res.Message)
    else
      ShowMessageModal('Export failed: ' + res.Message);
  end
  else
    ShowMessageModal('No policy loaded to export.');
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DM.CloseAll;
  if DM.ADOConnection1.Connected then
    DM.ADOConnection1.Connected := False;
end;

function TFrmMain.ComputeTotals(out TotalAmount: Currency; out TotalTax: Currency): Integer;
var
  curAmount: Currency;
  curTax: Currency;
  thresholdForDecision: Currency;
  highValueCount: Integer;
begin
  TotalAmount := 0;
  TotalTax := 0;
  highValueCount := 0;
  thresholdForDecision := 10000.00;

  if not DM.qPayments.Active then
  begin
    Result := -1;
    Exit;
  end;

  DM.qPayments.First;
  while not DM.qPayments.Eof do
  begin
    curAmount := DM.qPayments.FieldByName('Amount').AsCurrency;
    curTax := DM.qPayments.FieldByName('TaxWithheld').AsCurrency;

    if curTax = 0 then
    begin
      curTax := RoundTo(curAmount * GetTaxRateForDate(DM.qPayments.FieldByName('ValueDate').AsDateTime), -2);
    end;

    TotalAmount := TotalAmount + curAmount;
    TotalTax := TotalTax + curTax;

    if curAmount >= thresholdForDecision then
      Inc(highValueCount);

    DM.qPayments.Next;
  end;

  Result := DM.qPayments.RecordCount;

  lblTotalPayments.Caption := Format('Total Payments: %m  (Tax: %m)', [TotalAmount, TotalTax]);

  if highValueCount > 0 then
    lblDecision.Caption := 'Contains high-value payments - review required'
  else
    lblDecision.Caption := 'Payments OK';
end;

procedure TFrmMain.DoBusinessRules(const PolicyNo: string; TotalAmount: Currency; TotalTax: Currency);
begin
  if TotalAmount <= 0 then
  begin
    ShowMessageModal('No payment amounts found for policy ' + PolicyNo);
    Exit;
  end;

  if TotalTax / TotalAmount > 0.20 then
  begin
    LogSnippet(Format('Policy %s has high tax ratio: %f', [PolicyNo, TotalTax / TotalAmount]));
    SendReportToService(PolicyNo, 'High tax ratio flagged');
  end;
end;

procedure TFrmMain.ShowMessageModal(const Text: string);
begin
  MessageBox(Handle, PChar(Text), 'Clanad Demo', MB_OK or MB_ICONINFORMATION);
end;

end.
