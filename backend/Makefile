.PHONY: test

dev-prod-auth:
	$(MAKE) AUTH0_KEY=priv/auth/prod.pem dev

dev:
	$(MAKE) reset-db
	$(MAKE) seed-db
	elixir --name wallet@127.0.0.1 -S mix phx.server

test:
	$(MAKE) MIX_ENV=test reset-db
	mix test

test-watch:
	$(MAKE) MIX_ENV=test reset-db
	mix test.watch

shell:
	ERL_AFLAGS="-kernel shell_history enabled" iex --name wallet-console@127.0.0.1 --remsh wallet@127.0.0.1

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

expired-token:
	@mix run -e "WalletWeb.Auth0.print_expired_token"

routes:
	@mix phx.routes WalletWeb.Router
