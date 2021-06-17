defmodule BankAPI.Accounts.Projectors.AccountOpenedTest do
  use BankAPI.ProjectorCase

  alias BankAPI.Accounts.Projections.Account
  alias BankAPI.Accounts.Events.AccountOpened
  alias BankAPI.Accounts.Projectors.AccountOpened, as: Projector
  
  test "should succeed with valid data" do
    uuid = UUID.uuid4()

    account_opened_evt = %AccountOpened{
      account_uuid: uuid,
      initial_balance: 1_000
    }

    last_seen_event_number = get_last_seen_event_number("BankAPI.Accounts.Projectors.AccountOpened")

    assert :ok == Projector.handle(account_opened_evt, %{handler_name: "BankAPI.Accounts.Projectors.AccountOpened", event_number: last_seen_event_number + 1})

    current_balance =  only_instance_of(Account).current_balance
    account_uuid = only_instance_of(Account).uuid
    assert current_balance == 1_000
    assert  account_uuid == uuid
  end
end
