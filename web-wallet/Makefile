run: build
	cd server && npm start

build: build-ui build-server

build-ui:
	$(MAKE) -C ui build

build-server:
	$(MAKE) -C server build
