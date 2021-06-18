defmodule BankAPI.CommandRouter do
  use Commanded.Commands.Router
  

  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.{OpenAccount, CloseAccount}

  middleware BankAPI.Middleware.ValidateCommand
  
  dispatch([OpenAccount, CloseAccount], to: Account, identity: :account_uuid)
end
