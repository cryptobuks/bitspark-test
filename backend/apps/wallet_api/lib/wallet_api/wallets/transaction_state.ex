defmodule WalletApi.Wallets.TransactionState do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  @foreign_key_type :string
  schema "transaction_states" do
  end

  @doc false
  def changeset(transaction_state, attrs) do
    transaction_state
    |> cast(attrs, [])
    |> validate_required([])
  end
end
