defmodule Wallet.OnChain do
  use GenServer
  alias Wallet.Wallets

  defmodule State do
    defstruct foo: 0
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  @impl true
  def init(%State{} = state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:start, %State{} = state) do
    schendule_synchronization()
    {:noreply, state}
  end

  @impl true
  def handle_info(:synchronize, %State{} = state) do
    # Do the desired work here
    IO.puts "Synchronizing..."

    Wallets.synchronize_on_chain_transactions()

    # Schedule next synchronization
    schendule_synchronization()
    {:noreply, state}
  end

  def schendule_synchronization() do
    Process.send_after(self(), :synchronize, :timer.seconds(1))
  end
end
