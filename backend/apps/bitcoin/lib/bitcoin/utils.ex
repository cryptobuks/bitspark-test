defmodule Bitcoin.Amount do
  alias Decimal, as: D

  @doc """
  Validations

      iex> Bitcoin.validate_amount({21_000_000, :btc})
      :ok

      iex> Bitcoin.validate_amount({-21_000_000, :btc})
      :ok

      iex> Bitcoin.validate_amount({21_000_000 + 1, :btc})
      {:error, "Amount exceeds Bitcoin limit"}

      iex> Bitcoin.validate_amount({-21_000_000 - 1, :btc})
      {:error, "Amount exceeds Bitcoin limit"}

  """
  def validate_amount({amount, unit}) do
    max_btc = 2_100_000_000_000_000
    satoshi = to_satoshi({amount, unit})
    if (satoshi > max_btc or satoshi < -max_btc) do
      {:error, "Amount exceeds Bitcoin limit"}
    else
      :ok
    end
  end

  def is_positive_amount({amount, _unit}) do
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

  @doc """
  Lightning

      iex> Bitcoin.is_invoice("lntb10n1pdctf20pp5s6aj9rum8rez4w93058a7hheqdtq2vmex8a7j8e87jxcqgqlx32sdqg235xjmn8cqzysttrrdt3yucpl6dfzrke47cp3pxea5km99ujgj2ttagx80s9xmznqh778gctz87azkm6cvr3qqxxyecayfa78r7j00mfuae40n468wccp3f0mlv")
      true

      iex> Bitcoin.is_invoice("foo")
      false

  """
  def is_invoice(s) do
    cond do
      not String.starts_with?(s, "lntb") -> false
      true -> true
    end
  end

  @doc """
  Returns amount stored in invoice in satoshi

      iex> Bitcoin.invoice_satoshi("lntb10n1pdctf20pp5s6aj9rum8rez4w93058a7hheqdtq2vmex8a7j8e87jxcqgqlx32sdqg235xjmn8cqzysttrrdt3yucpl6dfzrke47cp3pxea5km99ujgj2ttagx80s9xmznqh778gctz87azkm6cvr3qqxxyecayfa78r7j00mfuae40n468wccp3f0mlv")
      1

  """
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
