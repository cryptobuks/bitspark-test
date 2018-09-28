defmodule Wallet.Schema.LightningTransactions do
  @moduledoc false

  require Logger
  alias Wallet.Accounts
  alias Wallet.Wallets

  @doc """
  Process lightning transaction.
  """
  def process_lightning_transaction(%{input: input}, %{context: context}) do
    wallet = context.assigns.joken_claims["sub"]
    |> Accounts.login!
    |> Wallets.get_or_create_wallet!

    with {:ok, %Wallet.Wallets.Transaction{} = trn} <- Wallet.Wallets.pay_invoice(wallet.id, input.invoice) do
      {:ok, %{transaction: trn}}
    else
      error ->
        {:error, error}
    end
  end
end
