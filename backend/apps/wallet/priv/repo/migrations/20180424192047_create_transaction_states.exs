defmodule Wallet.Repo.Migrations.CreateTransactionStates do
  use Ecto.Migration
  alias Wallet.Wallets

  def change do
    create table(:transaction_states, primary_key: false) do
      add :id, :string, primary_key: true
    end

    flush()

    {3, nil} = Wallet.Repo.insert_all(Wallets.TransactionState, [
      %{id: "initial"},
      %{id: "approved"},
      %{id: "declined"}
    ])
  end

  def down do
    drop table(:transaction_states)
  end
end
