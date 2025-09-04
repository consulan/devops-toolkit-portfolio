# Makefile interactivo para K3s/K8s
SHELL := /bin/bash
.ONESHELL:
.PHONY: init

init:
	@echo "=== Init de despliegue ==="
	@read -p "Namespace (default=default): " NS; \
	if [ -z "$$NS" ]; then NS=default; fi; \
	if kubectl get ns "$$NS" >/dev/null 2>&1; then \
		echo "Usando namespace '$$NS'."; \
	else \
		read -p "El namespace '$$NS' no existe. ¿Crearlo desde YAML? [y/N]: " CREATE; \
		if [[ "$$CREATE" =~ ^[Yy]$$ ]]; then \
			read -p "Ruta al YAML de Namespace: " NSFILE; \
			if [ -z "$$NSFILE" ] || [ ! -f "$$NSFILE" ]; then echo "Archivo de namespace inválido."; exit 1; fi; \
			if kubectl apply -f "$$NSFILE"; then \
				echo "Namespace creado OK."; \
			else \
				echo "ERROR creando namespace."; exit 1; \
			fi; \
		else \
			echo "Abortado: no existe el namespace y no se creó."; exit 1; \
		fi; \
	fi; \
	read -p "¿Aplicar un YAML en el namespace '$$NS'? [y/N]: " APPLY; \
	if [[ "$$APPLY" =~ ^[Yy]$$ ]]; then \
		read -p "Ruta del YAML a aplicar: " FILE; \
		if [ -z "$$FILE" ] || [ ! -f "$$FILE" ]; then echo "Archivo de despliegue inválido."; exit 1; fi; \
		if kubectl apply -n "$$NS" -f "$$FILE"; then \
			echo "Despliegue OK en '$$NS'."; \
		else \
			echo "ERROR aplicando el YAML en '$$NS'."; exit 1; \
		fi; \
	else \
		echo "Fin: no se aplicó ningún YAML."; \
	fi
