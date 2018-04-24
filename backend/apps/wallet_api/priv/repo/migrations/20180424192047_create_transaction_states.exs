defmodule WalletApi.Repo.Migrations.CreateTransactionStates do
  use Ecto.Migration
  alias WalletApi.Wallets.TransactionState

  def change do
    create table(:transaction_states, primary_key: false) do
      add :id, :string, primary_key: true
    end

    flush()

    WalletApi.Repo.insert!(%TransactionState{id: "approved"})
    WalletApi.Repo.insert!(%TransactionState{id: "declined"})
    WalletApi.Repo.insert!(%TransactionState{id: "initial"})
  end

  def down do
    drop table(:transaction_states)
  end
end
