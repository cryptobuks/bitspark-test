defmodule Bitcoin.Amount do
  alias Decimal, as: D

  @doc """
  Validations

      iex> Bitcoin.Amount.validate({21_000_000, :btc})
      :ok

      iex> Bitcoin.Amount.validate({-21_000_000, :btc})
      :ok

      iex> Bitcoin.Amount.validate({21_000_000 + 1, :btc})
      {:error, "Amount exceeds Bitcoin limit"}

      iex> Bitcoin.Amount.validate({-21_000_000 - 1, :btc})
      {:error, "Amount exceeds Bitcoin limit"}

  """
  def validate({amount, unit}) do
    max_btc = 2_100_000_000_000_000
    satoshi = to_satoshi({amount, unit})
    if (satoshi > max_btc or satoshi < -max_btc) do
      {:error, "Amount exceeds Bitcoin limit"}
    else
      :ok
    end
  end

  def is_positive({amount, _unit}) do
    if amount > 0 do
      :ok
    else
      {:error, "Non-positive amount given"}
    end
  end

  @doc """
  Conversions

      iex> Bitcoin.Amount.to_satoshi({1, :btc})
      100_000_000

      iex> Bitcoin.Amount.to_satoshi({1, :mbtc})
      100_000

      iex> Bitcoin.Amount.to_msatoshi({1, :btc})
      100_000_000_000

  """
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
end
