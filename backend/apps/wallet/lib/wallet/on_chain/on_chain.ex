defmodule Wallet.OnChain do
  use GenServer
  alias Wallet.Wallets

  @gold_module Keyword.get(Application.get_env(:wallet, Wallet.OnChain), :gold_module)

  defmodule State do
    defstruct foo: 0
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  def create_address do
    @gold_module.getnewaddress(:wallet_btcd)
  end

  @impl true
  def init(%State{} = state) do
    schendule_synchronization()
    {:ok, state}
  end

  @impl true
  def handle_cast(:start, %State{} = state) do
    schendule_synchronization()
    {:noreply, state}
  end

  @impl true
  def handle_info(:synchronize, %State{} = state) do
    # For testing purposes synchronize only last 5 transactions
    last_n_transactions = 5
    # http://chainquery.com/bitcoin-api/listtransactions
    # Sorted from oldest to newest
    {:ok, btcd_transactions} = @gold_module.listtransactions(:wallet_btcd, "", last_n_transactions)

    Wallets.synchronize_on_chain_transactions(btcd_transactions)

    # Schedule next synchronization
    schendule_synchronization()
    {:noreply, state}
  end

  def schendule_synchronization() do
    Process.send_after(self(), :synchronize, :timer.seconds(1))
  end
end
