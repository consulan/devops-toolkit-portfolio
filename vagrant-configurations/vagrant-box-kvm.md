# Vagrant Box

## Descripción

El **Vagrant Box** es una imagen de Vagrant alojada públicamente en HashiCorp Cloud, preparada con software de desarrollo, herramientas de testing (como K3s, etc.), compiladores, entre otros. Su propósito principal es facilitar la configuración de entornos de desarrollo y pruebas. Algunas de sus aplicaciones incluyen:

- Uniformar el entorno del equipo de desarrollo, preconfigurando las máquinas virtuales para que los desarrolladores se concentren únicamente en su área de trabajo.
- Desplegar entornos de testing para pruebas con configuraciones complejas como K3s o Kubernetes.
- Mantener un conjunto de herramientas específicas (DevOps, Networking, Infraestructura, etc.).
- Mantener la máquina local limpia frente a distintos clientes o ambientes de desarrollo.

---

## Creación de Vagrant Box (VB) - RHEL 9.5

### Descripción

Se utilizó un hipervisor **VMWare Workstation 16** en una máquina con 128GB de RAM para crear la imagen base (Golden Image) en una VM con **RHEL 9.5**. A continuación, se detallan los pasos realizados:

### Instalación de paquetes necesarios

```bash
dnf update -y
dnf install -y cloud-init sudo openssh-server curl wget net-tools
systemctl enable cloud-init
useradd -m vagrant
curl -L https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
```

### Limpieza de la VM

```bash
dnf clean all
rm -rf /tmp/*
truncate -s 0 /var/log/wtmp /var/log/btmp
```

### Exportación de la VM a formato qcow2

```bash
export TMPDIR=/var/tmp/sysprep-tmp
virt-sysprep -d rhel9.5
virt-sparsify --compress rhel9.5 /directory/rhel9.5-slim.qcow2
```

**Nota:** `virt-sysprep` elimina datos específicos de la instalación, actuando como un anonimizador.

---

## Testing Locales

### Archivos necesarios

- Imagen base: `box.img` (nombre obligatorio).

```bash
cp <archivo_comprimido>.qcow box.img
```

### Vagrantfile

```ruby
Vagrant.configure("2") do |config|
    config.vm.box = "rhel95-kvm"
    config.vm.provider :libvirt do |libvirt|
        libvirt.memory = 1024
        libvirt.cpus = 1
    end
    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        mkdir -p /home/vagrant/.ssh
        curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
        chown -R vagrant:vagrant /home/vagrant/.ssh
        chmod 700 /home/vagrant/.ssh
        chmod 600 /home/vagrant/.ssh/authorized_keys
    SHELL
end
```

### metadata.json

```json
{
    "provider": "libvirt",
    "format": "qcow2",
    "virtual_size": 20
}
```

---

## Preparación para Testing

### Empaquetado

```bash
tar cvzf rhel95local.box metadata.json Vagrantfile box.img
vagrant box add --name rhel95-kvm ./rhel95local.box
```

### Prueba en directorio local

```bash
mkdir prueba_vm && cd prueba_vm
vagrant init rhel95local
vagrant up rhel95local
```

---

## Prueba en Cloud

1. Subir el archivo `.box` a HashiCorp Cloud.
2. Asignar un nombre al box, seleccionar visibilidad pública y agregar una descripción.
3. Configurar el versionado inicial.
4. Seleccionar el proveedor (para VMWare Workstation es `i386`).
5. Realizar el upload y release.

### Ejemplo de prueba desde la consola web

```bash
vagrant init consulanregistry/rhel95-vmware-cloud --box-version 0.0.1
Vagrant.configure("2") do |config|
    config.vm.box = "consulanregistry/rhel95base"
    config.vm.box_version = "0.0.1"
end
vagrant up
```
