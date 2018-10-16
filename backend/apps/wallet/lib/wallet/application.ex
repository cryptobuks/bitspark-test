defmodule Wallet.Application do
  @moduledoc """
  The Wallet Application Service.

  The wallet system business domain lives in this application.

  Exposes API to clients such as the `WalletWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Wallet.Repo, []),
      supervisor(TestableNaiveDateTime, []),
      supervisor(Wallet.CurrencyRates, []),
      supervisor(Wallet.OnChain, []),
    ], strategy: :one_for_one, name: Wallet.Supervisor)
  end
end
