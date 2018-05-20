defmodule Wallet.WalletsTest do
  use Wallet.DataCase

  alias Wallet.Accounts
  alias Wallet.Accounts.User
  alias Wallet.Wallets

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

    def create_wallet() do
      {:ok, user} = Accounts.create_user(%{sub: "xyz"})
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
end
