defmodule Wallet do
  @moduledoc """
  Wallet keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def lightning_config(), do: Application.get_env(:wallet, Lightning)
end
