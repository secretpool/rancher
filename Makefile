DOCKER_CERT_PATH	:= ./certs
DOCKER_HOST 		:= tcp://159.89.141.210:2376
DOCKER_MACHINE_NAME := rancher

ifeq ($(machine),)
	machine = rancher
endif

ifeq ($(machine_size),)
	machine_size = s-2vcpu-4gb
endif

ifeq ($(vhost),)
	vhost = rancher.secretpool.org
endif

ifeq ($(access_token),)
	access_token = 107c684cc64c22cc9d5e89804993d060d3d3f23409555bbf45617a41aa34d84f
endif

all: deploy

deploy:
	docker-compose up -d

create-password:
	docker run --entrypoint htpasswd registry:2 -Bbn admin wMl2?5VgSuEaVCbC > auth/htpasswd
	docker cp auth/htpasswd rancher_registry_1:/auth

logs:
	docker-compose logs -f

ssh:
	docker exec -it rancher_registry_1 bash

provision-server:
	docker-machine create \
		--driver digitalocean \
		--digitalocean-access-token $(access_token) \
		--digitalocean-region sfo2 \
		--digitalocean-size $(machine_size) \
		$(machine)
