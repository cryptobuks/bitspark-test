defmodule Wallet.WalletsTest do
  import AssertValue
  import Utils, only: [canonicalize: 1]
  use Wallet.DataCase
  use Bamboo.Test

  alias Wallet.Accounts
  alias Wallet.Accounts.User
  alias Wallet.Wallets

  setup do
    on_exit(:reset, fn ->
      TestableNaiveDateTime.reset()
    end)
  end

  describe "wallets" do
    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{user_id: "15dbe34c-3099-46eb-aa1e-054b8339d4ed"}

    def create_user(attrs \\ %{}) do
      {:ok, user} = Accounts.create_user(Enum.into(attrs, %{sub: "foo"}))
      user
    end

    def wallet_fixture(attrs \\ %{}) do
      user = create_user()

      {:ok, wallet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{user_id: user.id})
        |> Wallets.create_wallet()

      wallet
    end

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Wallets.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Wallets.get_wallet!(wallet.id) == %{wallet | balance: 0}
    end

    test "create_wallet/1 with valid data creates a wallet" do
      %User{:id => user_id} = create_user()
      assert {:ok, %Wallets.Wallet{} = wallet} = Wallets.create_wallet(
        Enum.into(%{user_id: user_id}, @valid_attrs))
      assert wallet.user_id == user_id
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallets.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      assert {:ok, wallet} = Wallets.update_wallet(wallet, @update_attrs)
      assert %Wallets.Wallet{} = wallet
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallets.update_wallet(wallet, @invalid_attrs)
      assert %{wallet | balance: 0} == Wallets.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallets.Wallet{}} = Wallets.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Wallets.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Wallets.change_wallet(wallet)
    end
  end

  describe "transactions" do
    @valid_attrs %{state: "initial", description: "some description", invoice: "some invoice", msatoshi: 42}
    @update_attrs %{state: "approved", description: "some updated description", invoice: "some updated invoice", msatoshi: 43}
    @invalid_attrs %{state: nil, description: nil, invoice: nil, msatoshi: nil}

    def create_wallet(sub \\ "xyz") do
      {:ok, user} = Accounts.create_user(%{sub: sub})
      {:ok, wallet} = Wallets.create_wallet(%{user_id: user.id})
      wallet
    end

    def transaction_fixture(attrs \\ %{}) do
      wallet = create_wallet()
      {:ok, transaction} =
        attrs
        |> Enum.into(%{wallet_id: wallet.id})
        |> Enum.into(@valid_attrs)
        |> Wallets.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Wallets.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Wallets.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      wallet = create_wallet()
      assert {:ok, %Wallets.Transaction{} = transaction} = Wallets.create_transaction(
        Enum.into(%{wallet_id: wallet.id}, @valid_attrs))
      assert transaction.description == "some description"
      assert transaction.invoice == "some invoice"
      assert transaction.msatoshi == 42
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallets.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, transaction} = Wallets.update_transaction(transaction, @update_attrs)
      assert %Wallets.Transaction{} = transaction
      assert transaction.description == "some updated description"
      assert transaction.invoice == "some updated invoice"
      assert transaction.msatoshi == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallets.update_transaction(transaction, @invalid_attrs)
      assert transaction == Wallets.get_transaction!(transaction.id)
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Wallets.change_transaction(transaction)
    end
  end

  describe "wallet - on-chain transactions" do
    test "synchronize_on_chain_transactions/1 creates initial transaction (confirmations < 6)" do
      wallet = create_wallet()
      addr1 = "addr1"
      Wallets.create_on_chain_address(%{wallet_id: wallet.id, address: addr1})

      btcd_transactions = [
        %Gold.Transaction{
          address: addr1,
          amount: Bitcoin.Amount.to_btc({1000, :msatoshi}),
          blockhash: "00000000000002d61da8f097242b683c1d877af7a4f857b242fa150855411627",
          blockindex: 3,
          category: :receive,
          comment: nil,
          confirmations: 5,
          time: 1539582515,
          timereceived: 1539582515,
          txid: "02633f69aacfd7595baa923243f249e0f36db52e45ae67e6571b66612f2b321",
          vout: 0}
      ]
      Wallets.synchronize_on_chain_transactions(btcd_transactions)

      [trn] = Wallets.list_transactions(wallet)

      assert_value canonicalize(
                     trn
                     |> Map.take([
                       :state,
                       :msatoshi,
                       :on_chain_address_id,
                       :on_chain_confirmations,
                       :on_chain_txid,
                       :inserted_at,
                       :processed_at
                     ])
                   ) == %{
                     inserted_at: "<NAIVEDATETIME>",
                     msatoshi: 1000,
                     on_chain_address_id: "<UUID>",
                     on_chain_confirmations: 5,
                     on_chain_txid:
                       "02633f69aacfd7595baa923243f249e0f36db52e45ae67e6571b66612f2b321",
                     processed_at: nil,
                     state: "initial"
                   }
    end

    test "synchronize_on_chain_transactions/1 creates approved transaction (confirmations >= 6)" do
      wallet = create_wallet()
      addr1 = "addr1"
      Wallets.create_on_chain_address(%{wallet_id: wallet.id, address: addr1})

      btcd_transactions = [
        %Gold.Transaction{
          address: addr1,
          amount: Bitcoin.Amount.to_btc({1000, :msatoshi}),
          blockhash: "00000000000002d61da8f097242b683c1d877af7a4f857b242fa150855411627",
          blockindex: 3,
          category: :receive,
          comment: nil,
          confirmations: 6,
          time: 1539582515,
          timereceived: 1539582515,
          txid: "02633f69aacfd7595baa923243f249e0f36db52e45ae67e6571b66612f2b321",
          vout: 0}
      ]
      Wallets.synchronize_on_chain_transactions(btcd_transactions)

      [trn] = Wallets.list_transactions(wallet)

      assert_value canonicalize(
                     trn
                     |> Map.take([
                       :state,
                       :msatoshi,
                       :on_chain_address_id,
                       :on_chain_confirmations,
                       :on_chain_txid,
                       :inserted_at,
                       :processed_at
                     ])
                   ) == %{
                     inserted_at: "<NAIVEDATETIME>",
                     msatoshi: 1000,
                     on_chain_address_id: "<UUID>",
                     on_chain_confirmations: 6,
                     on_chain_txid:
                       "02633f69aacfd7595baa923243f249e0f36db52e45ae67e6571b66612f2b321",
                     processed_at: "<NAIVEDATETIME>",
                     state: "approved"
                   }
    end

    test "synchronize_on_chain_transactions/1 updates initial transaction to approved (confirmations >= 6)" do
      wallet = create_wallet()
      addr1 = "addr1"
      Wallets.create_on_chain_address(%{wallet_id: wallet.id, address: addr1})

      trn1_0conf = %Gold.Transaction{
        address: addr1,
        amount: Bitcoin.Amount.to_btc({1000, :msatoshi}),
        blockhash: "00000000000002d61da8f097242b683c1d877af7a4f857b242fa150855411627",
        blockindex: 3,
        category: :receive,
        comment: nil,
        confirmations: 0,
        time: 1539582515,
        timereceived: 1539582515,
        txid: "02633f69aacfd7595baa923243f249e0f36db52e45ae67e6571b66612f2b321",
        vout: 0
      }

      # Create an initial trasaction
      Wallets.synchronize_on_chain_transactions([trn1_0conf])
      [initial_trn] = Wallets.list_transactions(wallet)
      assert_value canonicalize(initial_trn |> Map.take([:state, :processed_at])) == %{
                     processed_at: nil,
                     state: "initial"
                   }

      # Process same on-chain transaction again (should be noop)
      Wallets.synchronize_on_chain_transactions([trn1_0conf])
      [initial_trn2] = Wallets.list_transactions(wallet)
      assert initial_trn == initial_trn2

      # Process the transaction, but now with 6+ confirmations
      trn1_6conf = Map.put(trn1_0conf, :confirmations, 6)
      Wallets.synchronize_on_chain_transactions([trn1_6conf])
      [approved_trn] = Wallets.list_transactions(wallet)
      assert_value canonicalize(approved_trn |> Map.take([:state, :processed_at])) == %{
                     processed_at: "<NAIVEDATETIME>",
                     state: "approved"
                   }
    end
  end

  describe "wallet - claimable transactions" do
    def claimable_trn_fixture(attrs \\ %{}) do
      wallet = create_wallet("claimable_trn_fixture")
      Wallets.create_funding_transaction(wallet)

      {:ok, %Wallets.Transaction{} = trn} = Wallets.create_claimable_transaction(
        wallet,
        amount: Map.get(attrs, :amount, {1, :satoshi}),
        description: Map.get(attrs, :description, "foo"),
        expires_after: Map.get(attrs, :expires_after, 60)
      )

      trn
    end

    test "create_claimable_transaction/2 with valid data creates a transaction with token and sends email" do
      wallet = create_wallet()
      Wallets.create_funding_transaction(wallet)

      assert {:ok, %Wallets.Transaction{} = transaction} = Wallets.create_claimable_transaction(
        wallet, amount: {1, :satoshi}, description: "foo", to_email: "to@example.com")

      assert_value canonicalize(transaction) == %Wallet.Wallets.Transaction{
                     __meta__: "<META>",
                     claim_expires_at: "<NAIVEDATETIME>",
                     claim_token: "<UUID>",
                     claimed_by: nil,
                     description: "foo",
                     id: "<UUID>",
                     inserted_at: "<NAIVEDATETIME>",
                     invoice: nil,
                     msatoshi: -1000,
                     processed_at: nil,
                     response: nil,
                     src_transaction_id: nil,
                     state: "initial",
                     to_email: "to@example.com",
                     updated_at: "<NAIVEDATETIME>",
                     wallet_id: "<UUID>"
                   }

      assert_delivered_email Wallet.Email.claim_transaction_email(
        "to@example.com", transaction.claim_token)
    end

    test "create_claimable_transaction/2 fails if wallet doesn't have enough funds" do
      wallet = create_wallet()
      Wallets.create_funding_transaction(wallet, amount: {1000, :msatoshi})
      {:ok, src_trn} = Wallets.create_claimable_transaction(wallet, amount: {1001, :msatoshi}, description: "foo")

      # It should be declined
      assert_value canonicalize(src_trn |> Map.take([:state, :response])) == %{response: "NSF", state: "declined"}
      assert_value canonicalize(Wallets.get_wallet!(wallet.id) |> Map.take([:balance])) == %{balance: 1000}

      # And not claimable
      dst_wallet = create_wallet("dst")
      assert_value Wallets.claim_transaction(dst_wallet, src_trn.claim_token) ==
                     {:error,
                      %Wallet.ValidationError{
                        details: "Non-initial state (declined)",
                        message: "Non-claimable transaction"
                      }}
      assert_value canonicalize(Wallets.get_wallet!(dst_wallet.id) |> Map.take([:balance])) == %{balance: 0}
    end

    test "claimable transaction should be claimable" do
      expires_after = 900

      src_wallet = create_wallet("sub1")
      Wallets.create_funding_transaction(src_wallet, amount: {1000, :msatoshi})

      # Source transaction
      {:ok, src_trn} = Wallets.create_claimable_transaction(
        src_wallet, amount: {1000, :msatoshi}, description: "foo", expires_after: expires_after)

      # Claim
      dst_wallet = create_wallet("sub2")
      {:ok, %Wallets.Transaction{} = dst_trn} = Wallets.claim_transaction(dst_wallet, src_trn.claim_token)

      # Wallet balances are updated correctly
      assert_value canonicalize(Wallets.get_wallet!(src_wallet.id) |> Map.take([:balance])) == %{balance: 0}
      assert_value canonicalize(Wallets.get_wallet!(dst_wallet.id) |> Map.take([:balance])) == %{balance: 1000}

      src_trn_after = Wallets.get_transaction!(src_trn.id)
      assert_value canonicalize(src_trn_after |> Map.take([:claimed_by, :processed_at, :state])) == %{claimed_by: "<UUID>", processed_at: "<NAIVEDATETIME>", state: "approved"}
      assert src_trn_after.claimed_by == dst_trn.id

      assert_value (canonicalize(dst_trn) |> Map.take([:description, :processed_at, :state, :msatoshi, :src_transaction_id])) == %{
        description: "foo",
        msatoshi: 1000,
        processed_at: "<NAIVEDATETIME>",
        src_transaction_id: "<UUID>",
        state: "approved"
      }

      # Claimed transaction don't change after it's expiration
      TestableNaiveDateTime.advance_by(:timer.seconds(expires_after + 1))

      src_trn_after_expiration = Wallets.get_transaction!(src_trn.id)
      assert_value canonicalize(src_trn_after_expiration) == canonicalize(src_trn_after)
    end

    test "claimable transaction should be only claimed once (same wallet)" do
      # Source transaction
      src_trn = claimable_trn_fixture(%{amount: {1000, :msatoshi}, description: "foo"})

      # Claim
      dst_wallet = create_wallet("dst")
      {:ok, dst_trn} = Wallets.claim_transaction(dst_wallet, src_trn.claim_token)
      assert_value Wallets.get_wallet_balance(dst_wallet) == 1000

      # Claim #2 should return same dst_trn
      assert {:ok, dst_trn} == Wallets.claim_transaction(dst_wallet, src_trn.claim_token)
      assert_value Wallets.get_wallet_balance(dst_wallet) == 1000
    end

    test "claimable transaction should be only claimed once (different wallet)" do
      # Source transaction
      src_trn = claimable_trn_fixture(%{amount: {1000, :msatoshi}, description: "foo"})

      # Claim
      dst_wallet = create_wallet("dst")
      {:ok, _} = Wallets.claim_transaction(dst_wallet, src_trn.claim_token)

      # Claim #2 fails when different wallet tries it
      different_wallet = create_wallet("dst_different")
      assert_value Wallets.claim_transaction(different_wallet, src_trn.claim_token) ==
                     {:error,
                      %Wallet.ValidationError{
                        details: "Non-initial state (approved)",
                        message: "Non-claimable transaction"
                      }}
      assert_value Wallets.get_wallet_balance(dst_wallet) == 1000
      assert_value Wallets.get_wallet_balance(different_wallet) == 0
    end

    test "claimable transaction isn't claimable after it expires" do
      # Source transaction (expired)
      src_trn = claimable_trn_fixture(%{expires_after: 900})

      TestableNaiveDateTime.advance_by(:timer.seconds(900 + 1))

      # Claim
      dst_wallet = create_wallet("dst")
      assert_value canonicalize(Wallets.claim_transaction(dst_wallet, src_trn.claim_token)) ==
                     {:error,
                      %Wallet.ValidationError{
                        details: "Non-initial state (declined)",
                        message: "Non-claimable transaction"
                      }}

      # Source transaction should be declined now
      src_trn_after = Wallets.get_transaction!(src_trn.id)
      assert_value canonicalize(src_trn_after) == %Wallet.Wallets.Transaction{
                     __meta__: "<META>",
                     claim_expires_at: "<NAIVEDATETIME>",
                     claim_token: "<UUID>",
                     claimed_by: nil,
                     description: "foo",
                     id: "<UUID>",
                     inserted_at: "<NAIVEDATETIME>",
                     invoice: nil,
                     msatoshi: -1000,
                     processed_at: "<NAIVEDATETIME>",
                     response: "Expired",
                     src_transaction_id: nil,
                     state: "declined",
                     to_email: nil,
                     updated_at: "<NAIVEDATETIME>",
                     wallet_id: "<UUID>"
                   }
      assert src_trn.claim_expires_at == src_trn_after.processed_at
    end
  end
end
