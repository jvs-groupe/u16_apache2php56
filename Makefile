# Si besoin à remplacer le nom de l'utilisateur docker final
DOCKER_USER=jvsgroupe

# Map de port, si le 80 est déjà pris
PORT4:=127.0.0.1:8883
PORT8:=127.0.0.1:8888

# Nom du container
NAME:=u16_apache2php56

# Chemin courant = real_path
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Id, ... de docker
RUNNING:=$(shell docker ps | grep $(NAME) | cut -f 1 -d ' ')
ALL:=$(shell docker ps -a | grep $(NAME) | cut -f 1 -d ' ')

# Options de la ligne de commande
DOCKER_RUN_COMMON=--name="$(NAME)" -p $(PORT8):80 -p $(PORT4):443 -v $(ROOT_DIR):/var/www/html -v $(ROOT_DIR)/docker-logs:/var/log/apache2 $(DOCKER_USER)/$(NAME)

# Par défaut le build
all: build

# Compilation de l'image
build: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	mkdir -p $(ROOT_DIR)/www
	docker build -t="$(DOCKER_USER)/$(NAME)" .

# Démarrage du container
run: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	mkdir -p $(ROOT_DIR)/www
	docker run -d $(DOCKER_RUN_COMMON)

# Arrêt du container
stop: clean

# Démarrage d'un bash sur le container
bash: clean
	mkdir -p $(ROOT_DIR)/docker-logs
	mkdir -p $(ROOT_DIR)/www
	docker run -t -i $(DOCKER_RUN_COMMON) /bin/bash

# Supprime les containers existants
clean:
ifneq ($(strip $(RUNNING)),)
	docker stop $(RUNNING)
endif
ifneq ($(strip $(ALL)),)
	docker rm $(ALL)
endif

# Nettoyage complet !!!
deepclean: clean
	rm -rf $(ROOT_DIR)/docker-logs
