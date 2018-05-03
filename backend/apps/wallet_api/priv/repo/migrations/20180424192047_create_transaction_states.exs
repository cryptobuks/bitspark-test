defmodule WalletApi.Repo.Migrations.CreateTransactionStates do
  use Ecto.Migration
  alias WalletApi.Wallets.TransactionState

  def change do
    create table(:transaction_states, primary_key: false) do
      add :id, :string, primary_key: true
    end

    flush()

    {3, nil} = WalletApi.Repo.insert_all(TransactionState, [
      %{id: "initial"},
      %{id: "approved"},
      %{id: "declined"}
    ])
  end

  def down do
    drop table(:transaction_states)
  end
end
