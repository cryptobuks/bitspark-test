defmodule Wallet.Schema.Enums do
  use Absinthe.Schema.Notation

  @moduledoc false

  @desc "Transaction processing state."
  enum :transaction_state do
    value :initial, description: "Pending transaction (e.g., non-exired email transaction which hasn't been claimed yet)."
    value :approved, description: "Successfuly processed transaction (final state)."
    value :declined, description: "Failed transaction (final state)."
  end
end
