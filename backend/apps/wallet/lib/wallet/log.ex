defmodule Wallet.Log do
  require Logger
  alias Wallet.Wallets.Transaction

  def processed_transaction(%Transaction{} = trn) do
    time = NaiveDateTime.diff(trn.processed_at, trn.inserted_at, :millisecond)
    Logger.info("PROCESSED_TRANSACTION wallet_id=#{trn.wallet_id} trn_id=#{trn.id} result=#{trn.state} msatoshi=#{trn.msatoshi} time=#{time} ms")
  end
end
