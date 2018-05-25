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

logs:
	docker-compose logs --timestamps --follow web-wallet backend

stop:
	docker-compose -f docker-compose.yml stop
