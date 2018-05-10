FROM elixir:1.6-alpine

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.2.ez

ENV MIX_ENV prod
ENV PORT ${PORT:-4000}
EXPOSE $PORT

COPY mix.exs ./
COPY apps/wallet_api/mix.exs ./apps/wallet_api/

RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .

RUN mix compile


CMD mix do ecto.migrate, phx.server