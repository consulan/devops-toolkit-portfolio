# Variables
KUBECTL ?= kubectl
DIR ?=
FILE ?=
NAME ?=
PORT ?=

# HELP (se ejecuta con "make help")
help:
	@echo "Comandos disponibles:"
	@echo "  make apply DIR=<dir>         -> Aplica todos los YAML de un directorio"
	@echo "  make apply FILE=<file>       -> Aplica un archivo YAML específico"
	@echo "  make delete DIR=<dir>        -> Borra todos los YAML de un directorio"
	@echo "  make delete FILE=<file>      -> Borra un archivo YAML específico"
	@echo "  make get                     -> Lista pods, services y deployments"
	@echo "  make logs NAME=<pod>         -> Muestra logs de un Pod"
	@echo "  make describe NAME=<pod>     -> Describe un Pod"
	@echo "  make port-forward NAME=<pod> PORT=8080:80 -> Hace port-forward de un Pod"
	@echo "  make context                 -> Muestra el contexto actual de kubectl"

# Aplica recursos
apply:
ifeq ($(DIR),)
	$(if $(FILE), $(KUBECTL) apply -f $(FILE), $(error Debes definir DIR=<dir> o FILE=<file>))
else
	$(KUBECTL) apply -f $(DIR)/
endif

# Borra recursos
delete:
ifeq ($(DIR),)
	$(if $(FILE), $(KUBECTL) delete -f $(FILE), $(error Debes definir DIR=<dir> o FILE=<file>))
else
	$(KUBECTL) delete -f $(DIR)/
endif

# Lista recursos básicos
get:
	$(KUBECTL) get all

# Logs de un Pod específico
logs:
	$(KUBECTL) logs -f $(NAME)

# Describe un Pod específico
describe:
	$(KUBECTL) describe pod $(NAME)

# Port-forward de un Pod específico
port-forward:
	$(KUBECTL) port-forward pod/$(NAME) $(PORT)

# Contexto actual
context:
	$(KUBECTL) config current-context
