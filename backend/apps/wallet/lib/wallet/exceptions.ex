defmodule Wallet.NonSufficientFunds do
  @moduledoc """
  Raised when wallet doesn't have sufficient funds for given transaction.
  """

  defexception [:message, :wallet, :transaction, plug_status: 400]

  def exception([wallet: wallet, transaction: transaction]) do
    msg = "Wallet #{inspect wallet.id} doesn't have sufficient funds for #{inspect transaction.id}"
    %Wallet.NonSufficientFunds{
      message: msg,
      wallet: wallet,
      transaction: transaction
    }
  end
end
