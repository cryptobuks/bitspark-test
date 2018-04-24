defmodule WalletApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :sub, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :sub])
    |> validate_required([:sub])
    |> unique_constraint(:sub)
    |> unique_constraint(:id, name: "users_pkey")
  end
end
