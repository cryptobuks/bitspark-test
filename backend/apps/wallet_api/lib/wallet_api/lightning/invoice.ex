defmodule WalletApi.Lightning.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "invoices" do
    field :description, :string
    field :msatoshi, :integer
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:description, :msatoshi])
    |> validate_required([:description, :msatoshi])
  end
end
