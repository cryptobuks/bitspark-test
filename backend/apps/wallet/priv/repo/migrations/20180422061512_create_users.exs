defmodule Wallet.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :sub, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:sub])

  end
end
