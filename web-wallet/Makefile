build: build-ui build-server

dev:
	$(MAKE) -j 2 run-dev-ui run-dev-server

run: build
	cd server && npm start

build-ui:
	$(MAKE) -C ui build

build-server:
	$(MAKE) -C server build

run-dev-ui:
	$(MAKE) -C ui dev

run-dev-server:
	$(MAKE) -C server dev
