.PHONY: build

build: node_modules

node_modules: package.json package-lock.json
	npm install
	touch node_modules # so that it's never than package-lock.json
