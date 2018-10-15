defmodule Wallet.Wallets.OnChainAddress do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "on_chain_addresses" do
    field :address, :string
    field :wallet_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(on_chain_address, attrs) do
    on_chain_address
    |> cast(attrs, [:address, :wallet_id])
    |> validate_required([:address, :wallet_id])
    |> foreign_key_constraint(:wallet_id)
    |> unique_constraint(:address)
  end
end
