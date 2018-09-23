defmodule Wallet.Events do
  alias Wallet.Wallets

  def transaction_created(%Wallets.Transaction{} = trn) do
    publish(trn, current_user_wallet_updated: trn.wallet_id)
  end

  def transaction_updated(%Wallets.Transaction{} = trn) do
    publish(trn, current_user_wallet_updated: trn.wallet_id)
  end

  defp publish(payload, topics) do
    Absinthe.Subscription.publish(WalletWeb.Endpoint, payload, topics)
  end
end
