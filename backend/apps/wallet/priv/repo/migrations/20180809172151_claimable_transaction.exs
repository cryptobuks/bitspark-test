defmodule Wallet.Repo.Migrations.ClaimableTransaction do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :claim_token, :string
      add :claimed_by, references(:transactions, on_delete: :nothing, type: :binary_id)
      add :src_transaction_id, references(:transactions, on_delete: :nothing, type: :binary_id)
    end

    create index(:transactions, [:claim_token])
    create unique_index(:transactions, [:src_transaction_id])
  end
end
