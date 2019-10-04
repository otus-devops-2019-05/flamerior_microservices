DOCKER_LOGIN=flamerior
DOCKER_REPO_PASS=.creds
APP_DIR=src
MONITORING_DIR=monitoring

APPS = comment post ui blackbox-exporter prometheus alertmanager grafana telegraf trickster

COMMENT_PATH = $(APP_DIR)/comment
POST_PATH = $(APP_DIR)/post-py
UI_PATH = $(APP_DIR)/ui
BLACKBOX_EXPORTER_PATH = $(MONITORING_DIR)/blackbox-exporter
PROMETHEUS_PATH = $(MONITORING_DIR)/prometheus
GRAFANA_PATH = $(MONITORING_DIR)/grafana
ALERTMANAGER_PATH = $(MONITORING_DIR)/alertmanager
TELEGRAF_PATH = $(MONITORING_DIR)/telegraf
TRICKSTER_PATH = $(MONITORING_DIR)/trickster

COMMENT_PRE = $(shell echo $(shell find $(COMMENT_PATH) -type f))
POST_PRE = $(shell echo $(shell find $(POST_PATH) -type f))
UI_PRE = $(shell echo $(shell find $(UI_PATH) -type f))
BLACKBOX_EXPORTER_PRE = $(shell echo $(shell find $(BLACKBOX_EXPORTER_PATH) -type f))
PROMETHEUS_PRE = $(shell echo $(shell find $(PROMETHEUS_PATH) -type f))
GRAFANA_PRE = $(shell echo $(shell find $(GRAFANA_PATH) -type f))
ALERTMANAGER_PRE = $(shell echo $(shell find $(ALERTMANAGER_PATH) -type f))
TELEGRAF_PRE = $(shell echo $(shell find $(TELEGRAF_PATH) -type f))
TRICKSTER_PRE = $(shell echo $(shell find $(TRICKSTER_PATH) -type f))

# HELP
# This will output the help for each task
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "> \033[33m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

# DOCKER
# Build images
build: build-comment build-post build-ui build-blackbox build-prometheus build-grafana build-alertmanager build-telegraf build-trickster

## Build docker images

build-comment: $(COMMENT_PRE) ## Build comment image
	docker build -t $(DOCKER_LOGIN)/comment $(COMMENT_PATH)

build-post: $(POST_PRE)## Build post image
	docker build -t $(DOCKER_LOGIN)/post $(POST_PATH)

build-ui: $(UI_PRE) ## Build ui image
	docker build -t $(DOCKER_LOGIN)/ui $(UI_PATH)

build-prometheus: $(PROMETHEUS_PRE) ## Build prometheus image
	docker build -t $(DOCKER_LOGIN)/prometheus $(PROMETHEUS_PATH)

build-grafana: $(GRAFANA_PRE) ## Build grafana image
	docker build -t $(DOCKER_LOGIN)/grafana $(GRAFANA_PATH)

build-alertmanager: $(ALERTMANAGER_PRE) ## Build alertmanager image
	docker build -t $(DOCKER_LOGIN)/alertmanager $(ALERTMANAGER_PATH)

build-telegraf: $(TELEGRAF_PRE) ## Build alertmanager image
	docker build -t $(DOCKER_LOGIN)/telegraf $(TELEGRAF_PATH)

build-trickster: $(TRICKSTER_PRE) ## Build alertmanager image
	docker build -t $(DOCKER_LOGIN)/trickster $(TRICKSTER_PATH)

build-blackbox: $(BLACKBOX_EXPORTER_PRE) ## Build blackbox-exporter image
	docker build -t $(DOCKER_LOGIN)/blackbox-exporter $(BLACKBOX_EXPORTER_PATH)

release: build push ## Make a release by building and publishing images to Docker Hub

# Docker push
push: docker-login publish-latest ## Publish the to Docker Hub

publish-latest: docker-login ## Publish the `latest` taged image to Docker HubDocker Hub
	@echo 'publish latest to $(DOCKER_LOGIN)'
	for app in $(APPS); do \
		docker push $(DOCKER_LOGIN)/$${app}:latest; \
	done

tag: ## Generate container tag
	@echo 'create comment tag'
	docker tag $(DOCKER_LOGIN)/comment
	@echo 'create post tag'
	docker tag $(DOCKER_LOGIN)/post
	@echo 'create ui tag'
	docker tag $(DOCKER_LOGIN)/ui


# Login to Docker Hub
docker-login: ## Login to Docker Hub
	test -s $(DOCKER_REPO_PASS) && cat $(DOCKER_REPO_PASS) | docker login --username $(DOCKER_LOGIN) --password-stdin || docker login --username $(DOCKER_LOGIN)
