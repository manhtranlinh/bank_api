defmodule BankAPI.Accounts.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__) 
  end

  def init(_arg) do
    children = [
      # %{id: :account_opened,
      # 	start: {BankAPI.Accounts.Projectors.AccountOpened, :start_link, []}
      #  }
      Supervisor.child_spec(BankAPI.Accounts.Projectors.AccountOpened, id: :account_opened)
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
