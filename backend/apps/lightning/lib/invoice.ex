defmodule Lightning.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "invoices" do
    field :description, :string
    field :msatoshi, :integer
    field :dst_pub_key, :string
    field :dst_alias, :string
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:description, :msatoshi, :dst_pub_key, :dst_alias])
    |> validate_required([:description, :msatoshi, :dst_pub_key])
  end
end
