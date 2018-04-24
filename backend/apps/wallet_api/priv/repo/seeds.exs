# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WalletApi.Repo.insert!(%WalletApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user1_id = "10000000-0000-0000-0000-000000000001"

WalletApi.Accounts.create_user(
  %{id: user1_id,
    sub: "testing"})

WalletApi.Wallets.create_wallet(
  %{id: "20000000-0000-0000-0000-000000000001",
    user_id: user1_id})
