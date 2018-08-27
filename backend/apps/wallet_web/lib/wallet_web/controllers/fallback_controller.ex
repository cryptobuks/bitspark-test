defmodule WalletWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WalletWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(WalletWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, %Wallet.ValidationError{} = error}) do
    conn
    |> put_status(:bad_request)
    |> render(WalletWeb.ErrorView, :"400", error)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(WalletWeb.ErrorView, :"404")
  end
end
