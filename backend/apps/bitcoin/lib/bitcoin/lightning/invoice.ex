defmodule Bitcoin.Lightning.Invoice do
  alias Decimal, as: D

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "invoices" do
    field :description, :string
    field :msatoshi, :integer
    field :dst_pub_key, :string
    field :dst_alias, :string
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:description, :msatoshi, :dst_pub_key, :dst_alias])
    |> validate_required([:description, :msatoshi, :dst_pub_key])
  end

  @doc """
  Lightning

      iex> Bitcoin.Lightning.Invoice.is_invoice("lntb10n1pdctf20pp5s6aj9rum8rez4w93058a7hheqdtq2vmex8a7j8e87jxcqgqlx32sdqg235xjmn8cqzysttrrdt3yucpl6dfzrke47cp3pxea5km99ujgj2ttagx80s9xmznqh778gctz87azkm6cvr3qqxxyecayfa78r7j00mfuae40n468wccp3f0mlv")
      true

      iex> Bitcoin.Lightning.Invoice.is_invoice("foo")
      false

  """
  def is_invoice(s) when is_bitstring(s) do
    cond do
      not String.starts_with?(s, "lntb") -> false
      true -> true
    end
  end

  @doc """
  Returns amount stored in invoice in satoshi

      iex> Bitcoin.Lightning.Invoice.invoice_satoshi("lntb10n1pdctf20pp5s6aj9rum8rez4w93058a7hheqdtq2vmex8a7j8e87jxcqgqlx32sdqg235xjmn8cqzysttrrdt3yucpl6dfzrke47cp3pxea5km99ujgj2ttagx80s9xmznqh778gctz87azkm6cvr3qqxxyecayfa78r7j00mfuae40n468wccp3f0mlv")
      {:ok, 1}

  """
  def invoice_satoshi(invoice) do
    with {:valid?, true} <- {:valid?, is_invoice(invoice)},
         {amount, rest} <- Integer.parse(String.slice(invoice, 4, 100)),
         {:ok, multiplier} <- parse_multiplier(String.slice(rest, 0, 1)) do
      {:ok, Bitcoin.Amount.to_satoshi({D.mult(amount, multiplier), :btc})}
    else
      {:error, reason} ->
        {:error, "Invalid invoice '#{invoice}' - #{reason}"}
      _ ->
        {:error, "Invalid invoice '#{invoice}'"}
    end
  end

  def invoice_msatoshi(invoice) do
    with {:ok, satoshi} <- invoice_satoshi(invoice) do
      satoshi * 1000
    end
  end

  defp parse_multiplier(char) do
    case char do
      "m" -> {:ok, "0.001" |> D.new}
      "u" -> {:ok, "0.000001" |> D.new}
      "n" -> {:ok, "0.000000001" |> D.new}
      "p" -> {:ok, "0.000000000001" |> D.new}
      _ -> {:error, "Invalid multiplier: #{char}"}
    end
  end
end
