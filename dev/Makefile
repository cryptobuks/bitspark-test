export LOGS_DST=syslog://splunk:1514

export FAKE_LND_ENABLED=1

export PAY_WALLET_URL=http://wallet.localhost
export CANTEEN_LND_REST_MACAROON=foobar
export CANTEEN_LND_REST_URL=http://backend:4000/fakelnd

export WALLET_LND_REST_MACAROON=foobar
export WALLET_LND_REST_URL=http://backend:4000/fakelnd

export SECRET_KEY_BASE=O4TlOvrI9TKTulX1QANJSkvKuIefrF9JU9EyuXue3D3+DFL78YendjgTdXWQ1V+J

run:
	$(MAKE) up

up:
	docker-compose build
	docker-compose up -d

restart-proxy:
	docker-compose restart proxy

logs:
	docker-compose logs --follow

db:
	docker-compose exec database createdb -U postgres wallet_prod

shell:
	docker-compose exec backend iex -S mix

stop:
	docker-compose stop
