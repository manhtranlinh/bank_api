defmodule BankAPI.Commanded do
  use Commanded.Application, otp_app: :bank_api
  
  router BankAPI.Router
  
  def init(config) do
    {:ok, config}
  end
end

# Van de nam o cho config the module nay, khac voi tutorial va co the noi gay ra loi
