defmodule BankAPI.CommandedApplication do
  use Commanded.Application, otp_app: :bank_api

  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.OpenAccount

  router BankAPI.CommandRouter

  def init(config) do
    {:ok, config}
  end

  # dispatch([OpenAccount], to: Account, identity: :account_uuid)
end

# Van de nam o cho config the module nay, khac voi tutorial va co the noi gay ra loi
