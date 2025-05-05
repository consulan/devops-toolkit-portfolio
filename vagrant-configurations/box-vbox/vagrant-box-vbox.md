# Vagrant Box  

## Descripción  

El Vagrant Box es una imagen de Vagrant alojada públicamente en HashiCorp Cloud, preparada con software de desarrollo, testing (como K3s, etc.), compiladores, entre otros. Sus principales usos incluyen:  

- Uniformar el entorno del equipo de desarrollo, preconfigurando las máquinas virtuales (VM) para que los desarrolladores se concentren en su área sin perder tiempo configurando el entorno.  
- Desplegar entornos de testing para pruebas con configuraciones complejas como K3s o K8s.  
- Mantener herramientas específicas (DevOps-tools, Networking-tools, Infrastructure-tools) en un entorno aislado.  
- Mantener la máquina local limpia frente a distintos clientes o ambientes de desarrollo.  

---

## Creación de Vagrant Box (VB) en Windows 10  

### Descripción  

Se utilizó VMware Workstation 16 como hipervisor en una máquina con 128GB de RAM para crear una VM con Windows 10. Dentro de esta, se habilitó Hyper-V para levantar una VM con RHEL95, simulando la función de Vagrant con Hyper-V como hipervisor.  

---

### Preparativos  

1. Instalar VirtualBox en Windows 10.  
2. Verificar requisitos.  
3. Crear una VM para instalar RHEL95 desde un ISO, configurando el disco como un único archivo.  
4. Instalar RHEL95 desde el ISO.  
5. Dentro de RHEL95:  
    - Crear el usuario `vagrant` e instalar la clave pública.  
    - Configurar el servidor SSH.  

```bash  
dnf update -y  
dnf install -y cloud-init sudo openssh-server curl wget net-tools  
systemctl enable cloud-init  

useradd -m vagrant  
curl -L https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys  
chmod 600 /home/vagrant/.ssh/authorized_keys  
chown -R vagrant:vagrant /home/vagrant/.ssh  
```  

6. Limpiar la VM:  

```bash  
dnf clean all  
rm -rf /tmp/*  
truncate -s 0 /var/log/wtmp /var/log/btm  
```  

7. Apagar la máquina.  

---

### Empaquetado en Windows  

1. Ir al directorio donde se exportó la VM (ejemplo: `E:\BOX`).  
2. Ejecutar el empaquetador de Vagrant:  

```bash  
vagrant package --base RHEL95-VBOX --output rhel95-vbox-local.box  
```  

3. Agregar el box al directorio local de boxes:  

```bash  
vagrant box add rhel95-vbox-local rhel95-vbox-local.box  
```  

4. Crear y ejecutar la VM en otro directorio:  

```bash  
vagrant init  
vagrant up  
```  

Opcionalmente, usar un `Vagrantfile` para automatizar implementaciones y provisión.  

---

## Prueba en Cloud  

1. Subir el archivo `.box` creando un nuevo box desde la consola visual.  
2. Configurar:  
    - Nombre del box.  
    - Visibilidad pública.  
    - Descripción.  
    - Versionado inicial.  
    - Proveedor (para VirtualBox es `i386`).  
3. Realizar el upload y release.  
4. Probar con los pasos indicados en la consola web:  

```bash  
vagrant init consulanregistry/rhel95-vbox-cloud --box-version 0.0.1  

Vagrant.configure("2") do |config|  
  config.vm.box = "consulanregistry/rhel95-vbox-cloud"  
  config.vm.box_version = "0.0.1"  
end  

vagrant up  
```  
