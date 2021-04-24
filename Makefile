all: build

deps:
	jpm deps

build: deps
	jpm build

test:
	janet ./test.janet

.PHONY: build
