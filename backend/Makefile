.PHONY: test

dev:
	$(MAKE) reset-db
	$(MAKE) seed-db
	mix phx.server

test:
	$(MAKE) MIX_ENV=test reset-db
	mix test

shell:
	iex -S mix

reset-db:
	mix do ecto.drop, ecto.create, ecto.migrate

seed-db:
	mix run apps/wallet_api/priv/repo/seeds.exs

connect-db:
	psql -h localhost wallet_api_dev postgres

seed:
	mix run apps/wallet_api/priv/repo/seeds.exs
