defmodule Wallet.ValidationError do
  defstruct message: "Validation error", details: "No details"
end

defmodule Wallet.Validation do
  alias Wallet.Wallets

  def maybe_validation_error({:error, message}),
    do: {:error, %Wallet.ValidationError{
            message: message,
            details: message}}

  def maybe_validation_error(x), do: x

  def expect_claimable_transaction(%Wallets.Transaction{
        claim_token: token}) when token == nil,
    do: {:error, %Wallet.ValidationError{
            message: "Non-claimable transaction",
            details: "Empty claim_token"}}

  def expect_claimable_transaction(%Wallets.Transaction{
        state: state}) when state != "initial",
    do: {:error, %Wallet.ValidationError{
            message: "Non-claimable transaction",
            details: "Non-initial state (#{state})"}}

  def expect_claimable_transaction(%Wallets.Transaction{}),
    do: :ok
end
