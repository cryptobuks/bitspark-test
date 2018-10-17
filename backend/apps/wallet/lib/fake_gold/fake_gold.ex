defmodule FakeGold do
  use Agent

  def getnewaddress(_name, _account \\ "") do
    {:ok, Utils.random_string(32)}
  end

  def listtransactions(_name, _account \\ "*", _limit \\ 10, _offset \\ 0) do
    {:ok, []}
  end
end
