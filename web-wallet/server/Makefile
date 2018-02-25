.PHONY: build
LNCLI ?= ../mocks/lncli

build: node_modules

dev: node_modules
	LNCLI=$(LNCLI) npm run dev

node_modules: package.json package-lock.json
	npm install
	touch node_modules # so that it's never than package-lock.json
