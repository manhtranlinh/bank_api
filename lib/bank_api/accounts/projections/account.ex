defmodule BankAPI.Accounts.Projections.Account do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "accounts" do
    field :current_balance, :integer
    timestamps([type: :utc_datetime])
  end
end
