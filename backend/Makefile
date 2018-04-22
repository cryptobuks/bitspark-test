.PHONY: test

dev:
	mix phx.server

test:
	mix test

shell:
	iex -S mix

reset-db:
	mix do ecto.rollback --all, ecto.migrate

connect-db:
	psql -h localhost wallet_api_dev postgres

seed:
	mix run apps/wallet_api/priv/repo/seeds.exs
