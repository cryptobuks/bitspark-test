defmodule WalletApiWeb.Router do
  use WalletApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WalletApiWeb do
    pipe_through :api
  end
end
