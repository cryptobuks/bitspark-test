run:
	git pull
	docker-compose -f docker-compose.yml build
	docker-compose -f docker-compose.yml up -d

logs:
	docker-compose logs --timestamps --follow web-wallet backend

stop:
	docker-compose -f docker-compose.yml stop
