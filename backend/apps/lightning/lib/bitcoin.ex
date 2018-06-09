defmodule Bitcoin do
  alias Decimal, as: D

  # Conversions
  def to_satoshi({amount, unit}) do
    D.div(to_msatoshi({amount, unit}), 1000) |> D.round |> D.to_integer
  end

  def to_msatoshi({amount, _}) when is_float(amount),
    do: raise("Do not use floats for BTC related amounts")

  def to_msatoshi({amount, :msatoshi}), do: amount

  def to_msatoshi({amount, unit}) when (is_integer(amount) or is_bitstring(amount)),
    do: to_msatoshi({D.new(amount), unit})

  def to_msatoshi({amount, :btc}),
      do: D.mult(amount, 100_000_000_000) |> D.to_integer

  def to_msatoshi({amount, :mbtc}),
      do: D.mult(amount, 100_000_000) |> D.to_integer

  def to_msatoshi({amount, :satoshi}),
    do: D.mult(amount, 1_000) |> D.to_integer

  # Lightning
  def is_invoice(s) do
    cond do
      not String.starts_with?(s, "lntb") -> false
      true -> true
    end
  end

  def invoice_satoshi(invoice) do
    # https://github.com/lightningnetwork/lightning-rfc/blob/master/11-payment-encoding.md
    {amount, rest} = Integer.parse(String.slice(invoice, 4, 100))
    multiplier =
      case String.slice(rest, 0, 1) do
        "m" -> "0.001" |> D.new
        "u" -> "0.000001" |> D.new
        "n" -> "0.000000001" |> D.new
        "p" -> "0.000000000001" |> D.new
        _ -> raise "Unknown invoice amount multiplier"
      end

    to_satoshi({D.mult(amount, multiplier), :btc})
  end

  def invoice_msatoshi(invoice) do
    invoice_satoshi(invoice) * 1000
  end
end
