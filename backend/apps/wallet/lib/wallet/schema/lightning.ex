defmodule Wallet.Schema.Lightning do
  @moduledoc false
  use Absinthe.Schema.Notation

  object :parsed_invoice do
    @desc "Amount in milli-satoshi (0.001 satoshi)."
    field :msatoshi, non_null(:msatoshi)
    field :description, non_null(:string)
  end

  @desc "The input for parse invoice."
  input_object :parse_invoice_input do
    field :invoice, non_null(:lightning_invoice)
  end

  ## Resolvers
  def parse_invoice(_root, %{input: input}, _context) do
    {:ok, _parsed} = Bitcoin.Lightning.decode_invoice(Wallet.lightning_config, input.invoice)
  end
end
