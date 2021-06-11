defmodule BankAPI.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :current_balance, :integer

      timestamps([type: :utc_datetime])
    end
  end
end
