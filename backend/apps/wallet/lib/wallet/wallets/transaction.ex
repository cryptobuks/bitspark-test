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
    field :to_email, :string
    field :claim_token, :binary_id
    field :claim_expires_at, :naive_datetime
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
    |> cast(attrs, [
          :wallet_id, :state, :description, :msatoshi, :invoice, :response, :processed_at,
          :to_email, :claim_token, :claim_expires_at, :claimed_by, :src_transaction_id])
    |> validate_required([:wallet_id, :state, :msatoshi])
    |> foreign_key_constraint(:state)
    |> foreign_key_constraint(:claimed_by)
    |> foreign_key_constraint(:src_transaction_id)
    |> unique_constraint(:src_transaction_id)
  end

  @doc """
  Try to determine transaction type by it's properties
  """
  def get_transaction_type(%{claim_token: value}) when value != nil, do: :claimable
  def get_transaction_type(%{invoice: value}) when value != nil, do: :lightning
  def get_transaction_type(%{}), do: :other

  @doc """
  Decide whether system should expire given claimable transaction

  Only initial with expired claim date should expire
  """
  def should_claimable_transaction_expire(%{state: "initial"} = trn) do
    NaiveDateTime.compare(trn.claim_expires_at, NaiveDateTime.utc_now) != :gt
  end

  def should_claimable_transaction_expire(_), do: false
end
