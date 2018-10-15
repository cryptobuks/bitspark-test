defmodule Wallet.Repo.Migrations.CreateOnChainAddressesTable do
  use Ecto.Migration

  def change do
    create table(:on_chain_addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :address, :string, null: false
      add :wallet_id, references(:wallets, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:on_chain_addresses, [:wallet_id])
    create unique_index(:on_chain_addresses, [:address])
  end
end
