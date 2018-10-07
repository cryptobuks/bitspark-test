defmodule Wallet.Schema.Scalars do
  use Absinthe.Schema.Notation

  @moduledoc false

  alias Ecto.UUID

  ## uuid
  scalar :uuid, name: "UUID" do
    serialize &UUID.cast!/1
    parse &cast_uuid/1
  end

  defp cast_uuid(%Absinthe.Blueprint.Input.String{value: value}) do
    UUID.cast(value)
  end

  defp cast_uuid(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp cast_uuid(_) do
    :error
  end

  ## msatoshi
  scalar :msatoshi, name: "MilliSatoshi" do
    description """
    Integer representing amount in milli-satoshi (0.001 satoshi). Fits safely into JavaScript integer range.

    - Maximum value 2100000000000000
    - Minimum value: -2100000000000000
    """

    serialize & &1
    parse parse_with([Absinthe.Blueprint.Input.Integer], &parse_msatoshi/1)
  end

  @max_msatoshi Bitcoin.Amount.to_msatoshi({21_000_000, :btc})
  @min_msatoshi -Bitcoin.Amount.to_msatoshi({21_000_000, :btc})

  @spec parse_msatoshi(any) :: {:ok, integer} | :error
  defp parse_msatoshi(value) when is_integer(value) and value >= @min_msatoshi and value <= @max_msatoshi do
    {:ok, value}
  end

  defp parse_msatoshi(_) do
    :error
  end

  # Parse, supporting pulling values out of blueprint Input nodes
  defp parse_with(node_types, coercion) do
    fn
      %{__struct__: str, value: value} ->
      if Enum.member?(node_types, str) do
        coercion.(value)
      else
        :error
      end

      %Absinthe.Blueprint.Input.Null{} ->
        {:ok, nil}

      other ->
        coercion.(other)
    end
  end
end
