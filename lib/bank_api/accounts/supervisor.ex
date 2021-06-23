defmodule BankAPI.Accounts.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__) 
  end

  def init(_arg) do
    children = [
      Supervisor.child_spec(BankAPI.Accounts.Projectors.AccountOpened, id: :account_opened),
      Supervisor.child_spec(BankAPI.Accounts.Projectors.AccountClosed, id: :account_closed),
      Supervisor.child_spec(BankAPI.Accounts.Projectors.DepositsAndWithdrawals, id: :deposits_and_withdrawals),
      Supervisor.child_spec(BankAPI.Accounts.ProcessManagers.TransferMoney, id: :transfer_money)
      
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
