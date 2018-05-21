defmodule Pay.Application do
  @moduledoc """
  The Pay Application Service.

  The pay system business domain lives in this application.

  Exposes API to clients such as the `PayWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
    ], strategy: :one_for_one, name: Pay.Supervisor)
  end
end
