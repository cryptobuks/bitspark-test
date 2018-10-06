defmodule Wallet.Schema.Transactions do
  @moduledoc false
  use Absinthe.Schema.Notation

  require Logger
  alias Wallet.Accounts
  alias Wallet.Wallets

  interface :transaction do
    field :id, non_null(:id)
    @desc "Transaction processing state."
    field :state, non_null(:transaction_state)
    @desc "Transaction amount."
    field :msatoshi, non_null(:msatoshi)
    @desc "Human readable description (e.g., purchased item description)."
    field :description, non_null(:string)

    resolve_type &transaction_type_resolver/2
  end

  def transaction_type_resolver(%Wallet.Wallets.Transaction{} = trn, _) do
    case trn do
      %{description: "Funding transaction"} -> :funding_transaction
      %{invoice: "" <> _} -> :lightning_transaction
      %{to_email: "" <> _} -> :email_transaction
      _ -> :other_transaction
    end
  end

  object :base_transaction do
    field :id, non_null(:id)
    field :state, non_null(:transaction_state),
      resolve: fn %Wallet.Wallets.Transaction{state: state}, _, _ -> {:ok, String.to_atom(state)} end
    field :msatoshi, non_null(:msatoshi)
    field :description, non_null(:string)
  end

  object :funding_transaction do
    import_fields :base_transaction
    interface :transaction
  end

  object :other_transaction do
    import_fields :base_transaction
    interface :transaction
  end

  ### Lightning transactions
  object :lightning_transaction do
    import_fields :base_transaction
    @desc "Lightning invoice (e.g., lntb32u1p...4qax)."
    field :invoice, non_null(:string)
    interface :transaction
  end

  @desc "The payload for lightning transaction processing."
  object :process_lightning_transaction_payload do
    @desc "Processed transaction."
    field :transaction, non_null(:lightning_transaction)
  end

  @desc "The input for lightning transaction processing."
  input_object :process_lightning_transaction_input do
    field :invoice, non_null(:string)
  end

  @doc """
  Process lightning transaction.
  """
  def process_lightning_transaction(%{input: input}, %{context: context}) do
    wallet = context.assigns.joken_claims["sub"]
    |> Accounts.login!
    |> Wallets.get_or_create_wallet!

    with {:ok, %Wallet.Wallets.Transaction{} = trn} <- Wallet.Wallets.pay_invoice(wallet.id, input.invoice) do
      {:ok, %{transaction: trn}}
    else
      {:error, reason} ->
        {:error, reason}
      _ ->
        {:error, "Unknown error"}
    end
  end

  ### Email transactions
  object :email_transaction do
    import_fields :base_transaction
    @desc "Email of payee who will receive instructions how to claim this transaction."
    field :to_email, non_null(:string)
    @desc "Date after which payee will be no longer able to claim the transaction."
    field :claim_expires_at, non_null(:naive_datetime)

    interface :transaction
  end

  @desc "The payload for email transaction processing."
  object :process_email_transaction_payload do
    @desc "Processed transaction."
    field :transaction, non_null(:email_transaction)
  end

  @desc "The input for email transaction processing."
  input_object :process_email_transaction_input do
    @desc "Payee email."
    field :to_email, non_null(:string)
    @desc "Transaction amount."
    field :msatoshi, non_null(:msatoshi)
    @desc "Transaction description visible to both payer & payee."
    field :description, :string
    @desc "Number of seconds after which transactions will no longer be claimable by payee."
    field :expires_after, non_null(:integer)
  end

  @doc """
  Process email transaction.
  """
  def process_email_transaction(%{input: input}, %{context: context}) do
    wallet = context.assigns.joken_claims["sub"]
    |> Accounts.login!
    |> Wallets.get_or_create_wallet!

    with {:ok, %Wallet.Wallets.Transaction{} = trn} <- Wallet.Wallets.create_claimable_transaction(
           wallet,
           to_email: input.to_email,
           amount: {input.msatoshi, :msatoshi},
           description: input.description,
           expires_after: input.expires_after) do
      {:ok, %{transaction: trn}}
    else
      {:error, reason} ->
        {:error, reason}
      _ ->
        {:error, "Unknown error"}
    end
  end
end
