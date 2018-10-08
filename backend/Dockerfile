FROM elixir:1.7-alpine

ARG FAKE_LND_ENABLED

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.4.ez

ENV FAKE_LND_ENABLED "${FAKE_LND_ENABLED}"
ENV MIX_ENV prod
ENV PORT ${PORT:-4000}
EXPOSE $PORT

COPY mix.lock ./
COPY mix.exs ./
COPY docker/run-backend ./
COPY apps/wallet/mix.exs ./apps/wallet/
COPY apps/wallet_web/mix.exs ./apps/wallet_web/
COPY apps/pay/mix.exs ./apps/pay/
COPY apps/pay_web/mix.exs ./apps/pay_web/

RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .

RUN mix compile


CMD ./run-backend
