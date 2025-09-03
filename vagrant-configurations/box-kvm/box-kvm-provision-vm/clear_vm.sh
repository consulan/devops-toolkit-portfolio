#!/bin/bash
set -e

echo "[INFO] Limpiando la máquina virtual..."
echo "Deteniendo VM..."
vagrant halt || {
  echo "[WARN] La máquina virtual ya está detenida o hubo un error."
}
echo "Borrando VM..."
vagrant destroy -f || {
  echo "[WARN] La máquina virtual ya está borrada o hubo un error."
}
echo "Eliminando archivos de configuración..."
rm -rf .vagrant || {
  echo "[WARN] No se encontraron archivos de configuración o hubo un error."
}
echo "Borrando box..."
vagrant box remove consulanregistry/rhel95base || { 
  echo "[WARN] No se encontró el box o hubo un error."
}
echo "Limpieza completa."
