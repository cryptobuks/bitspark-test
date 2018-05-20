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
	mix run apps/wallet/priv/repo/seeds.exs

run-db:
	docker rm -f wallet_pg > /dev/null 2>&1 || true
	docker run --detach -p 5432:5432 --env POSTGRES_DB=wallet_dev --name wallet_pg postgres:10.3

connect-db:
	docker exec -it wallet_pg psql wallet_dev postgres

seed:
	mix run apps/wallet/priv/repo/seeds.exs

token:
	@mix run -e "WalletWeb.Auth0.print_random_token"

routes:
	@mix phx.routes WalletWeb.Router
