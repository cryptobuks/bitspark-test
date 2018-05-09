defmodule WalletApi.Wallets.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  def initial, do: "initial"
  def approved, do: "approved"
  def declined, do: "declined"

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :wallet_id, :binary_id
    field :state, :string
    field :description, :string
    field :invoice, :string
    field :msatoshi, :integer
    field :processed_at, :naive_datetime
    field :response, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:wallet_id, :state, :description, :msatoshi, :invoice, :response, :processed_at])
    |> validate_required([:wallet_id, :state, :description, :msatoshi])
    |> foreign_key_constraint(:state)
  end
end
