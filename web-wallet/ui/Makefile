.PHONY: build

dev: node_modules
	npm run dev

build: node_modules
	npm run build

node_modules: package.json package-lock.json
	npm install
	touch node_modules # so that it's newer than package-lock.json
