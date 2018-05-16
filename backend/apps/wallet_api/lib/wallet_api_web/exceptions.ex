defmodule WalletApiWeb.InvalidInvoice do
  @moduledoc """
  Raised when invoice isn't valid.
  """

  defexception [:message, plug_status: 400]

  def exception([invoice: invoice]) do
    msg = "Given invoice #{inspect invoice} doesn't seem to be valid."
    %WalletApiWeb.InvalidInvoice{message: msg}
  end
end
