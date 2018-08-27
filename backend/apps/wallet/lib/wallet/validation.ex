defmodule Wallet.ValidationError do
  defstruct message: "Validation error"
end

defmodule Wallet.Validation do
  def maybe_validation_error({:error, message}),
    do: {:error, %Wallet.ValidationError{message: message}}

  def maybe_validation_error(x), do: x
end
