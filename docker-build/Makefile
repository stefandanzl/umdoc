.PHONY: all setup linux windows clean shell

all: setup
	docker-compose up --build

setup:
	mkdir -p output cmake
	cp mingw-w64-x86_64.cmake cmake/

linux: setup
	docker-compose --profile linux-only up linux-builder

windows: setup
	docker-compose --profile windows-only up windows-builder

shell: setup
	docker-compose --profile debug up shell

clean:
	rm -rf output
	docker-compose down
	docker rmi -f umdoc-docker-build_umdoc-builder