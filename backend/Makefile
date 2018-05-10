.PHONY: test

dev:
	$(MAKE) reset-db
	$(MAKE) seed-db
	mix phx.server

test:
	$(MAKE) MIX_ENV=test reset-db
	mix test

shell:
	ERL_AFLAGS="-kernel shell_history enabled" iex -S mix

reset-db:
	mix do ecto.drop, ecto.create, ecto.migrate

seed-db:
	mix run apps/wallet_api/priv/repo/seeds.exs

connect-db:
	psql -h localhost wallet_api_dev postgres

seed:
	mix run apps/wallet_api/priv/repo/seeds.exs

token:
	@mix run -e "WalletApiWeb.Auth0.print_random_token"

routes:
	@mix phx.routes WalletApiWeb.Router
