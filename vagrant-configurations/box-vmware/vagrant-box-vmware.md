# Vagrant Box VMware

## Descripción

El Vagrant Box es una imagen de Vagrant alojada públicamente en HashiCorp Cloud, preparada con software de desarrollo, testing (como K3s, etc.) y/o compiladores, entre otras herramientas. Se puede utilizar para:

- Uniformar el equipo de desarrollo y preconfigurar sus máquinas virtuales (VM), permitiendo que se concentren únicamente en el área de desarrollo sin perder tiempo configurando el entorno.
- Desplegar un entorno de testing para realizar pruebas con entornos complejos como K3s, K8s, etc.
- Mantener un conjunto de herramientas específicas (DevOps-tools, Networking-tools, Infrastructure-tools).
- Mantener la máquina local limpia frente a distintos clientes, ambientes de desarrollo o aplicaciones IT.

---

## Creación de Vagrant Box (VB) - Windows 10

### Descripción

Se utilizó VMware Workstation 16 en una máquina con 128GB de RAM para crear la Golden Image. Dentro de esta, se creó una VM con Windows 10, donde se instaló VMware Workstation 17. En esta segunda VM, se creó otra VM con RHEL 9.5 para generar la imagen de Vagrant.

Este proceso simula la funcionalidad de Vagrant con VMware Workstation.

---

### Preparativos

#### Software a instalar

1. **VMware Workstation 17**  
2. **Vagrant**  
    Descargar el ejecutable de Vagrant directamente desde HashiCorp e instalarlo.

#### Pasos

1. Crear una VM para instalar RHEL 9.5 desde un ISO. Configurar el disco como un único archivo.  
2. Instalar RHEL 9.5 desde el ISO.  
3. Dentro de RHEL 9.5:
    - Crear el usuario `vagrant` e instalar la clave pública.
    - Configurar el servidor SSH (`sshd`).

```bash
# Actualizar el sistema
dnf update -y

# Instalar dependencias
dnf install -y cloud-init sudo openssh-server curl wget net-tools

# Habilitar cloud-init
systemctl enable cloud-init

# Crear usuario vagrant y configurar SSH
useradd -m vagrant
curl -L https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
```

4. Limpiar la VM:

```bash
dnf clean all
rm -rf /tmp/*
truncate -s 0 /var/log/wtmp /var/log/btm
```

5. Apagar la máquina.  
6. En VMware Workstation, ir al menú `VM` → `Settings` → `Hard Disk` y hacer clic en `Compact` para minimizar el tamaño del disco.

---

### En Windows

1. Copiar los archivos `*.vmdk` y `*.vmx` del directorio de la VM a un directorio limpio.  
2. Crear un archivo `metadata.json` requerido por Vagrant:

```json
{
  "provider": "vmware_desktop",
  "version": "1.0.0",
  "name": "rhel9.5-vmware",
  "os": {
     "family": "redhat",
     "name": "rhel",
     "version": "9.5"
  }
}
```

3. Desde la consola de Windows (CMD), ejecutar:

```bash
tar cvzf rhel95-vmware.box metadata.json RHEL95-VMWARE.vmdk RHEL95-VMWARE.vmx
```

4. Copiar el archivo `.box` a otro directorio para mayor organización.  
5. Agregar el box al directorio local de boxes:

```bash
vagrant box add --name rhel95-vmware-local ./rhel95-vmware.box
```

6. Crear y ejecutar la VM:

```bash
vagrant init
vagrant up
```

Opcionalmente, utilizar o copiar un `Vagrantfile` para automatizar implementaciones y provisión.

---

## Prueba en Cloud

1. Subir el archivo `.box` creando un nuevo box desde la consola visual.  
2. Configurar:
    - Nombre del box en la nube.
    - Seleccionar `public`.
    - Agregar una descripción.
    - Versionar el box según corresponda.
    - Seleccionar el proveedor (para VMware Workstation es `i386`).  
3. Realizar el upload y release.  
4. Ejecutar los pasos de prueba indicados en la consola web:

```bash
vagrant init consulanregistry/rhel95-vmware-cloud --box-version 0.0.1

Vagrant.configure("2") do |config|
  config.vm.box = "consulanregistry/rhel95-vmware-cloud"
  config.vm.box_version = "0.0.1"
end

vagrant up
```
