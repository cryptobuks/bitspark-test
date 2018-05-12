defmodule Utils do
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def canonicalize(xs) when is_list(xs) do
    for x <- xs, do: canonicalize(x)
  end

  def canonicalize(x) when is_map(x) do
    List.foldl(
      Map.keys(x),
      x,
      fn(k, acc) -> Map.update!(acc, k, &(canonicalize(&1))) end
    )
  end

  def canonicalize(x) when is_bitstring(x) do
    x
    |> String.replace(~r/\d{4}-\d{2}-\d{2}.\d{2}:\d{2}:\d{2}\.\d+Z/, "<TIMESTAMPZ>")
    |> String.replace(~r/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+/, "<TIMESTAMP>")
    |> String.replace(~r"\w{8}-\w{4}-\w{4}-\w{4}-\w{12}", "<UUID>")
  end

  def canonicalize(x) do
    x
  end
end