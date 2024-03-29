build:
	docker build --build-arg ARCH=$(shell uname -m) --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) --build-arg UNAME=$(USER) --build-arg GNAME=$(shell id -gn) -t rmn_libs_tests -f Dockerfile .

build-nc:
	docker build --no-cache --build-arg ARCH=$(shell uname -m) --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) --build-arg UNAME=$(USER) --build-arg GNAME=$(shell id -gn) -t rmn_libs_tests -f Dockerfile .

run: build
	docker run -it rmn_libs_tests bash 

clean:
	docker image rm -f rmn_libs_tests
