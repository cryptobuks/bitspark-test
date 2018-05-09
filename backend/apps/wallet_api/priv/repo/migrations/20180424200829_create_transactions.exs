defmodule WalletApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :wallet_id, references(:wallets, on_delete: :nothing, type: :binary_id), null: false
      add :state, references(:transaction_states, on_delete: :nothing, type: :string), null: false
      add :description, :text, null: false
      add :msatoshi, :bigint, null: false
      add :invoice, :text
      add :processed_at, :naive_datetime
      add :response, :text

      timestamps()
    end

    create index(:transactions, [:wallet_id])
  end
end
