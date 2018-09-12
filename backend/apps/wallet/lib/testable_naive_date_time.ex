defmodule TestableNaiveDateTime do
  use Agent

  defmodule State do
    defstruct offset: 0
  end

  def start_link() do
    Agent.start_link(fn -> %State{} end, name: __MODULE__)
  end

  def get_offset() do
    Agent.get(__MODULE__, &Map.fetch(&1, :offset))
  end

  def set_offset(ms) do
    Agent.update(__MODULE__, &Map.put(&1, :offset, ms))
  end

  def reset() do
    Agent.update(__MODULE__, &Map.put(&1, :offset, 0))
  end

  def advance_by(ms) do
    Agent.update(__MODULE__, &Map.update!(&1, :offset, fn (current) -> current + ms end))
  end

  def utc_now do
    if Mix.env in [:dev, :test] do
      {:ok, ms} = get_offset()
      NaiveDateTime.add(NaiveDateTime.utc_now, ms, :millisecond)
    else
      NaiveDateTime.utc_now
    end
  end
end
