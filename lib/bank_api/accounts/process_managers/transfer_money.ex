defmodule BankAPI.Accounts.ProcessManagers.TransferMoney do
  use Commanded.ProcessManagers.ProcessManager,
    application: BankAPI.CommandedApplication,
    name: to_string(__MODULE__)


  alias __MODULE__

  alias BankAPI.Accounts.Commands.{DepositIntoAccount, WithdrawFromAccount}

  alias BankAPI.Accounts.Events.{
    DepositedIntoAccount,
    WithdrawnFromAccount,
    MoneyTransferRequested
  }

  @derive Jason.Encoder
  defstruct [:transfer_uuid, :source_account_uuid, :destination_account_uuid, :amount, :status]

  @doc """
  You will notice that the WithdrawFromAccount and DepositIntoAccount commands have been enhanced with a transfer_uuid field. 
  This is to distinguish deposits and withdrawals being done as part of a transfer, or single operations.
  That is why the interested?/1 hooks for these events match for when this field is missing so as to not handle them.

  """

  def interested?(%MoneyTransferRequested{transfer_uuid: transfer_uuid}) do
    {:start!, transfer_uuid}
  end

  def interested?(%WithdrawnFromAccount{transfer_uuid: transfer_uuid})
      when is_nil(transfer_uuid) do
    false
  end

  def interested?(%WithdrawnFromAccount{transfer_uuid: transfer_uuid}) do
    {:continue!, transfer_uuid}
  end

  def interested?(%DepositedIntoAccount{transfer_uuid: transfer_uuid}) when is_nil(transfer_uuid),
    do: false

  def interested?(%DepositedIntoAccount{transfer_uuid: transfer_uuid}) do
    {:stop, transfer_uuid}
  end

  def interested?(_event) do
    false
  end

  # handle functions
  def handle(%TransferMoney{}, %MoneyTransferRequested{
        source_account_uuid: source_account_uuid,
        amount: transfer_amount,
        transfer_uuid: transfer_uuid
      }) do
    %WithdrawFromAccount{
      account_uuid: source_account_uuid,
      withdraw_amount: transfer_amount,
      transfer_uuid: transfer_uuid
    }
  end

  def handle(%TransferMoney{transfer_uuid: transfer_uuid} = pm, %WithdrawnFromAccount{
        transfer_uuid: transfer_uuid
      }) do
    %DepositIntoAccount{
      account_uuid: pm.destination_account_uuid,
      deposit_amount: pm.amount,
      transfer_uuid: pm.transfer_uuid
    }
  end

  # state change
  def apply(%TransferMoney{} = pm, %MoneyTransferRequested{} = evt) do
    %TransferMoney{
      pm
      | transfer_uuid: evt.transfer_uuid,
        source_account_uuid: evt.source_account_uuid,
        destination_account_uuid: evt.destination_account_uuid,
        amount: evt.amount,
        status: :withdraw_money_from_source_account
    }
  end

  def apply(%TransferMoney{} = pm, %WithdrawnFromAccount{}) do
    %TransferMoney{
      pm
      | status: :deposit_money_in_destination_account
    }
  end
end
