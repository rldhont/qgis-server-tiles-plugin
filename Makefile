SHELL:=bash
#
# tiles server plugin makefile
#

COMMITID=$(shell git rev-parse --short HEAD)

REGISTRY_URL ?= 3liz
REGISTRY_PREFIX=$(REGISTRY_URL)/

# Qgis version flavor
FLAVOR:=3.16

BECOME_USER:=$(shell id -u)

QGIS_IMAGE=$(REGISTRY_PREFIX)qgis-platform:$(FLAVOR)

LOCAL_HOME ?= $(shell pwd)

# Checke setup.cfg for flake8 configuration
lint:
	@flake8

test:
	mkdir -p $$(pwd)/.local $(LOCAL_HOME)/.cache
	docker run --rm --name qgis-py-server-test-$(COMMITID) -w /src \
		-u $(BECOME_USER) \
		-v $$(pwd):/src \
		-v $$(pwd)/.local:/.local \
		-v $(LOCAL_HOME)/.cache:/.cache \
		-e PIP_CACHE_DIR=/.cache \
		-e PYTEST_ADDOPTS="$(TEST_OPTS)" \
		$(QGIS_IMAGE) ./tests/run-tests.sh

