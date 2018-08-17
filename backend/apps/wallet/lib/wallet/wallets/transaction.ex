defmodule Wallet.Wallets.Transaction do
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
    # Lightning
    field :invoice, :string
    # External claim (e.g., via email)
    field :claim_token, :string
    field :claimed_by, :binary_id
    field :src_transaction_id, :binary_id
    field :msatoshi, :integer
    field :processed_at, :naive_datetime
    field :response, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:wallet_id, :state, :description, :msatoshi, :invoice, :response, :processed_at, :claim_token, :claimed_by, :src_transaction_id])
    |> validate_required([:wallet_id, :state, :description, :msatoshi])
    |> foreign_key_constraint(:state)
    |> foreign_key_constraint(:claimed_by)
    |> foreign_key_constraint(:src_transaction_id)
    |> unique_constraint(:src_transaction_id)
  end
end
