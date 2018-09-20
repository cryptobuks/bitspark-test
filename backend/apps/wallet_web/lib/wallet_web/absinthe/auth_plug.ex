defmodule WalletWeb.Absinthe.AuthPlug do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    Absinthe.Plug.put_options(conn, context: %{assigns: conn.assigns})
  end
end
