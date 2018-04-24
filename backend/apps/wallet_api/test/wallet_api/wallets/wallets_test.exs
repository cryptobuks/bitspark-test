defmodule WalletApi.WalletsTest do
  use WalletApi.DataCase

  alias WalletApi.Accounts
  alias WalletApi.Accounts.User
  alias WalletApi.Wallets

  describe "wallets" do
    alias WalletApi.Wallets.Wallet

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
      assert Wallets.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      %User{:id => user_id} = create_user()
      assert {:ok, %Wallet{} = wallet} = Wallets.create_wallet(
        Enum.into(%{user_id: user_id}, @valid_attrs))
      assert wallet.user_id == user_id
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallets.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      assert {:ok, wallet} = Wallets.update_wallet(wallet, @update_attrs)
      assert %Wallet{} = wallet
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallets.update_wallet(wallet, @invalid_attrs)
      assert wallet == Wallets.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Wallets.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Wallets.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Wallets.change_wallet(wallet)
    end
  end
end
