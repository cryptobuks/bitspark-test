defmodule Wallet.Repo.Migrations.NullableTransactionDescription do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      modify :description, :text, null: true
    end
  end
end
