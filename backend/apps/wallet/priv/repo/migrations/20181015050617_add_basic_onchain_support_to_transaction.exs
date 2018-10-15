defmodule Wallet.Repo.Migrations.AddBasicOnchainSupportToTransaction do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :on_chain_address_id, references(:on_chain_addresses, on_delete: :nothing, type: :binary_id), null: true
      add :on_chain_txid, :string, null: true
      add :on_chain_confirmations, :integer, null: true
    end

    create unique_index(:transactions, [:on_chain_txid])
  end
end
