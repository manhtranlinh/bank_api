defmodule BankAPI.Accounts.Commands.OpenAccount do
  use Ecto.Schema
  import Ecto.Changeset

  @enforce_keys [:account_uuid]

  # Case 1: use struct 
  # defstruct [:account_uuid, :initial_balance]

  # Case 2: use embedded schema
  # embedded_schema do
  #   field :account_uuid
  #   field :initial_balance 
  # end

  # Case 3: use schema 
  schema "open_account" do
    field :account_uuid 
    field :initial_balance, :integer
  end

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Commands.Validators

  def changeset(open_account, attrs) do
    open_account
    |> cast(attrs, [:account_uuid, :initial_balance])
    |> validate_format(:account_uuid, Accounts.uuid_regex())
    |> validate_number(:initial_balance, greater_than: 0)
  end
  

  @spec valid?(Ecto.Schema.t()) :: :ok | {:error, term()}
  def valid?(command) do
    command
    |> change()
    |> validate_required([:account_uuid, :initial_balance])
    |> validate_format(:account_uuid, Accounts.uuid_regex())
    |> validate_number(:initial_balance, greater_than: 0)
    |> case do
      %{valid?: true} -> :ok
      %{valid?: false, errors: errors} -> {:error, errors}
    end
  end

  # def valid?(command) do
  #   Skooma.valid?(Map.from_struct(command), schema())
  # end

  # defp schema do
  #   %{
  #     account_uuid: [:string, Skooma.Validators.regex(Accounts.uuid_regex())],
  #     initial_balance: [:int, &Validators.positive_integer(&1)]
  #   }
  # end
end
