defmodule Wallet.Repo.Migrations.AddTrnToEmailColumn do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :to_email, :string, null: true
    end
  end
end
