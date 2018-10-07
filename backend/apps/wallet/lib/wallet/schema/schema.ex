defmodule Wallet.Schema do
  use Absinthe.Schema

  alias Wallet.Accounts
  alias Wallet.Wallets

  import_types Absinthe.Type.Custom
  import_types Wallet.Schema.Scalars
  import_types Wallet.Schema.Enums
  import_types Wallet.Schema.Wallets
  import_types Wallet.Schema.Transactions
  import_types Wallet.Schema.Lightning

  query do
    @desc """
    Wallet of currently authenticated user (via JWT token).
    """
    field :current_user_wallet, non_null(:wallet) do
      resolve &Wallet.Schema.Wallets.get_wallet/3
    end

    @desc """
    Parse Lightning invoice.
    """
    field :parse_invoice, non_null(:parsed_invoice) do
      arg :input, non_null(:parse_invoice_input)

      resolve &Wallet.Schema.Lightning.parse_invoice/3
    end
  end

  mutation do
    @desc "Process lightning transaction."
    field :process_lightning_transaction, type: :process_lightning_transaction_payload do
      arg :input, non_null(:process_lightning_transaction_input)

      resolve &Wallet.Schema.Transactions.process_lightning_transaction/2
    end

    @desc "Process email transaction."
    field :process_email_transaction, type: :process_email_transaction_payload do
      arg :input, non_null(:process_email_transaction_input)

      resolve &Wallet.Schema.Transactions.process_email_transaction/2
    end

    @desc "Claim transaction."
    field :claim_transaction, type: :claim_transaction_payload do
      arg :input, non_null(:claim_transaction_input)

      resolve &Wallet.Schema.Transactions.claim_transaction/2
    end
  end

  subscription do
    @desc """
    Returns updated Wallet object when wallet is somehow modified (e.g., new transaction is created).
    """
    field :current_user_wallet_updated, :wallet do
      config fn _, %{context: context} ->
        wallet = context.assigns.joken_claims["sub"]
        |> Accounts.login!
        |> Wallets.get_or_create_wallet!

        {:ok, topic: wallet.id}
      end

      resolve &Wallet.Schema.Wallets.get_wallet/3
    end
  end
end
