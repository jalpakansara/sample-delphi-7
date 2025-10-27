object DM: TDM
  Left = 0
  Top = 0
  Caption = 'DM'
  object ADOConnection1: TADOConnection
    Left = 8
    Top = 8
    LoginPrompt = False
    Name = 'ADOConnection1'
    ConnectionString = 'Provider=SQLOLEDB;Data Source=YOUR_SERVER;Initial Catalog=YOUR_DB;Integrated Security=SSPI;'
    Connected = False
  end
  object qPolicies: TADOQuery
    Left = 8
    Top = 56
    Name = 'qPolicies'
    SQL.Strings = (
      'SELECT PolicyNo, HolderName, StartDate, PremiumAmount'
      +' FROM Policies'
      +' WHERE PolicyNo = :PolicyNo'
    )
    Active = False
    Connection = ADOConnection1
  end
  object qPayments: TADOQuery
    Left = 8
    Top = 128
    Name = 'qPayments'
    SQL.Strings = (
      'SELECT PaymentID, PolicyNo, ValueDate, Amount, TaxWithheld'
      +' FROM Payments'
      +' WHERE PolicyNo = :PolicyNo'
      +' ORDER BY ValueDate'
    )
    Active = False
    Connection = ADOConnection1
  end
  object dsPolicies: TDataSource
    Left = 8
    Top = 200
    Name = 'dsPolicies'
    DataSet = qPolicies
  end
  object dsPayments: TDataSource
    Left = 8
    Top = 232
    Name = 'dsPayments'
    DataSet = qPayments
  end
end
