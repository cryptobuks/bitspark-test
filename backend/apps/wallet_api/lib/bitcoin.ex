defmodule Bitcoin do
  alias Decimal, as: D

  def to_msatoshi({amount, _}) when is_float(amount),
    do: raise("Do not use floats for BTC related amounts")

  def to_msatoshi({amount, unit}) when (is_integer(amount) or is_bitstring(amount)),
    do: to_msatoshi({D.new(amount), unit})

  def to_msatoshi({amount, :btc}),
      do: D.mult(amount, 100_000_000_000) |> D.to_integer

  def to_msatoshi({amount, :mbtc}),
      do: D.mult(amount, 100_000_000) |> D.to_integer
end
