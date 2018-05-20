defmodule Wallet.Wallets.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallets" do
    field :user_id, :binary_id
    field :balance, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:id, :user_id])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id)
    |> unique_constraint(:id, name: "wallets_pkey")
  end
end
