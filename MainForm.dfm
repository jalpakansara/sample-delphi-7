object FrmMain: TFrmMain
  Left = 0
  Top = 0
  BorderStyle = bsSizeable
  Caption = 'Clanad Demo - Main'
  ClientHeight = 450
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Align = alTop
    Height = 56
    BevelOuter = bvNone
    object lblPolicy: TLabel
      Left = 8
      Top = 16
      Caption = 'Policy No:'
    end
    object edtPolicyNo: TEdit
      Left = 72
      Top = 12
      Width = 160
      Name = 'edtPolicyNo'
    end
    object btnLoad: TButton
      Left = 248
      Top = 8
      Width = 88
      Height = 28
      Caption = 'Load Policy'
      Name = 'btnLoad'
      OnClick = btnLoadClick
    end
    object btnExport: TButton
      Left = 344
      Top = 8
      Width = 88
      Height = 28
      Caption = 'Export'
      Name = 'btnExport'
      OnClick = btnExportClick
    end
  end
  object DBGridPolicies: TDBGrid
    Left = 8
    Top = 64
    Width = 384
    Height = 320
    DataSource = DM.dsPolicies
    Name = 'DBGridPolicies'
  end
  object DBGridPayments: TDBGrid
    Left = 400
    Top = 64
    Width = 384
    Height = 320
    DataSource = DM.dsPayments
    Name = 'DBGridPayments'
  end
  object lblTotalPayments: TLabel
    Left = 8
    Top = 392
    Width = 384
    Height = 24
    Caption = 'Total Payments:'
    Name = 'lblTotalPayments'
  end
  object lblDecision: TLabel
    Left = 400
    Top = 392
    Width = 384
    Height = 24
    Caption = 'Decision:'
    Name = 'lblDecision'
  end
  OnClose = FormClose
end
