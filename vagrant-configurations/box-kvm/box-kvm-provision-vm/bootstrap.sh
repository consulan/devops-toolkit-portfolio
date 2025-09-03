#!/bin/bash
set -e

# VARIABLES - reemplazá con tu cuenta de Red Hat Developer
RH_USER="juortiz@ca.gob.ar"
RH_PASS="${RH_PASS}"

if [[ -z "$RH_PASS" ]]; then
  echo "[ERROR] La variable de entorno RH_PASS no está definida."
  exit 1
fi

echo "[INFO] Registrando el sistema en Red Hat..."
echo "[INFO] Usuario: ${RH_USER}"
echo "[INFO] Password: ${RH_PASS}"

subscription-manager register \
  --username="${RH_USER}" \
  --password="${RH_PASS}" \
  --force || {
    echo "[WARN] Ya registrado o error. Continuando..."
}

echo "Update del sistema..."
dnf upate -y 


echo "[INFO] Instalando EPEL y dependencias base..."
dnf install -y epel-release
dnf install -y python3 python3-pip git curl

echo "[INFO] Instalando Ansible..."
pip3 install ansible

echo "[INFO] Verificando instalación..."
ansible --version

echo "[INFO] Quitando el registro el sistema con Red Hat Subscription Manager..."
subscription-manager unregister || {
  echo "[WARN] Ya registrado o hubo error. Continuando..."
}
