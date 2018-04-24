defmodule WalletApi.Wallets.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :wallet_id, :binary_id
    field :state, :string
    field :description, :string
    field :invoice, :string
    field :msatoshi, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:wallet_id, :state, :description, :msatoshi, :invoice])
    |> validate_required([:wallet_id, :state, :description, :msatoshi])
  end
end
