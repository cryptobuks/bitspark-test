defmodule Wallet.Repo.Migrations.ClaimableTransaction do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :claim_token, :binary_id
      add :claim_expires_at, :naive_datetime
      add :claimed_by, references(:transactions, on_delete: :nothing, type: :binary_id)
      add :src_transaction_id, references(:transactions, on_delete: :nothing, type: :binary_id)
    end

    create unique_index(:transactions, [:claim_token])
    create unique_index(:transactions, [:src_transaction_id])
  end
end
