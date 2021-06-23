defmodule BankAPI.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BankAPI.Repo
  alias BankAPI.CommandedApplication

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount,
    TransferBetweenAccounts
  }

  alias BankAPI.Accounts.Projections.Account
  alias BankAPI.CommandRouter, as: Router

  def uuid_regex do
    ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  end

  def get_account(id) do
    case Repo.get(Account, id) do
      %Account{} = account -> {:ok, account}
      _reply -> {:error, :not_found}
    end
  end

  def close_account(id) do
    %CloseAccount{
      account_uuid: id
    }
    |> Router.dispatch(application: CommandedApplication)
  end

  def open_account(%{"initial_balance" => initial_balance}) do
    account_uuid = UUID.uuid4()

    dispatch_result =
      %OpenAccount{
        initial_balance: initial_balance,
        account_uuid: account_uuid
      }
      |> Router.dispatch(application: CommandedApplication)

    case dispatch_result do
      :ok ->
        {:ok,
         %Account{
           uuid: account_uuid,
           current_balance: initial_balance,
           status: Account.status().open
         }}

      reply ->
        reply
    end
  end

  def open_account(_params), do: {:error, :bad_command}

  def deposit(id, amount) do
    dispatch_result =
      %DepositIntoAccount{account_uuid: id, deposit_amount: amount}
      |> Router.dispatch(application: CommandedApplication, consistency: :strong)

    case dispatch_result do
      :ok -> {:ok, Repo.get!(Account, id)}
      reply -> reply
    end
  end

  def withdraw(id, amount) do
    dispatch_result =
      %WithdrawFromAccount{account_uuid: id, withdraw_amount: amount}
      |> Router.dispatch(application: CommandedApplication, consistency: :strong)

    case dispatch_result do
      :ok -> {:ok, Repo.get!(Account, id)}
      reply -> reply
    end
  end

  def transfer(source_id, amount, destination_account_id) do
    %TransferBetweenAccounts{
      account_uuid: source_id,
      transfer_uuid: UUID.uuid4(),
      transfer_amount: amount,
      destination_account_uuid: destination_account_id
    }
    |> Router.dispatch(application: CommandedApplication)
  end
end
