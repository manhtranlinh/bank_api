defmodule BankAPI.CommandedApplication do
  use Commanded.Application, otp_app: :bank_api

  router(BankAPI.CommandRouter)

  def init(config) do
    {:ok, config}
  end
end
