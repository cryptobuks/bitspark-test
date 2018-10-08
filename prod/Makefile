export WALLET_LND_REST_URL=https://bit-1.c.bitspark-195811.internal:29735
export CANTEEN_LND_REST_URL=https://bit-1.c.bitspark-195811.internal:29736

run:
	git tag -f prev current
	git pull
	$(MAKE) up

run-prev:
	git reset --hard prev
	$(MAKE) up

up:
	docker-compose -f docker-compose.yml build
	docker-compose -f docker-compose.yml up -d
	git tag -f current

restart-proxy:
	docker-compose restart proxy

logs:
	papertrail --group biluminate --follow

shell:
	docker-compose exec backend iex --name wallet-console@127.0.0.1 --remsh wallet@127.0.0.1

bash:
	bash

stop:
	docker-compose -f docker-compose.yml stop
