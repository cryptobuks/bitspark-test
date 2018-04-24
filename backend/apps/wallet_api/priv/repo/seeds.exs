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

{:ok, user1} = WalletApi.Accounts.create_user(
  %{id: "10000000-0000-0000-0000-000000000001",
    sub: "testing"})

{:ok, wallet1} = WalletApi.Wallets.create_wallet(
  %{id: "20000000-0000-0000-0000-000000000001",
    user_id: user1.id})

{:ok, _trn1} = WalletApi.Wallets.create_transaction(
  %{wallet_id: wallet1.id,
    state: "approved",
    description: "Funding transaction",
    msatoshi: 1_000_000_000
  })

{:ok, _trn1} = WalletApi.Wallets.create_transaction(
  %{wallet_id: wallet1.id,
    state: "declined",
    description: "Some declined transaction",
    msatoshi: 100_000_000
  })
