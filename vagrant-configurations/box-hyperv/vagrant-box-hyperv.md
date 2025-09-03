# Vagrant Box Hyper-V  

## Descripción  

El Vagrant Box es una imagen de Vagrant alojada públicamente en HashiCorp Cloud, preparada con software de desarrollo, herramientas de testing (como K3s) y compiladores, entre otros. Su propósito principal es facilitar la configuración de entornos de desarrollo y testing.  

### Usos principales:  
- Uniformar el equipo de desarrollo y preconfigurar sus máquinas virtuales para que se concentren en el desarrollo sin perder tiempo configurando el entorno.  
- Desplegar entornos de testing para pruebas con configuraciones complejas como K3s o Kubernetes.  
- Mantener herramientas específicas para distintos tipos de trabajos (DevOps, Networking, Infraestructura).  
- Mantener la máquina local limpia frente a distintos clientes o ambientes de desarrollo.  

---

## Creación de Vagrant Box (Windows 10 con Hyper-V)  

### Descripción  
Se utilizó VMware Workstation 16 como hipervisor para crear una imagen base (Golden Image) en una máquina con 128GB de RAM. Dentro de esta, se habilitó Hyper-V en Windows 10 para levantar una VM con RHEL 9.5.  

### Preparativos en VM dentro del VMWare
1. **Habilitar Hyper-V en Windows 10:**  
    - `Win + R` → "control panel" → "Programs" → "Turn Windows features on or off" → Seleccionar "Hyper-V" → "OK".  

2. **Crear la VM para RHEL 9.5:**  
    - Crear la VM con un único archivo para el disco.  
    - Instalar RHEL 9.5 desde el ISO.  

3. **Configurar RHEL 9.5:**  
    ```bash  
    dnf update -y  
    dnf install -y cloud-init sudo openssh-server curl wget net-tools  
    systemctl enable cloud-init  

    useradd -m vagrant  
    curl -L https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys  
    chmod 600 /home/vagrant/.ssh/authorized_keys  
    chown -R vagrant:vagrant /home/vagrant/.ssh  
    ```  

4. **Limpiar la VM:**  
    ```bash  
    dnf clean all  
    rm -rf /tmp/*  
    truncate -s 0 /var/log/wtmp /var/log/btm  
    ```  

5. **Apagar la máquina y exportar:**  
    - Remover snapshots con PowerShell:  
      ```powershell  
      Get-VM -Name "RHEL95-HYPERV" | Get-VMSnapshot | Remove-VMSnapshot  
      $vmPath = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Machines"  
      Export-VM -Name "RHEL95-HYPERV" -Path "E:\BASE-VAGRANT\RHEL95-HYPERV"  
      ```  

6. **Compactar el disco:**  
    - Usar Hyper-V Manager: "Actions" → "Edit Disk" → Ejecutar Wizard y buscar el archivo `.vhdx`.  

---

### Crear el Vagrant Box  

1. **Crear archivo `metadata.json`:**  
    ```json  
    {  
      "provider": "hyperv",  
      "format": "vagrant_hyperv_box",  
      "virtual_size": 20,  
      "version": "1.0.0"  
    }  
    ```  

2. **Crear `Vagrantfile`:**  
    ```ruby  
    Vagrant.configure("2") do |config|  
      config.vm.box = "rhel95-hyperv-local"  
      config.vm.synced_folder ".", "/vagrant", disabled: true  
      config.vm.provider "hyperv" do |h|  
         h.vmname = "rhel95-vm"  
      end  
    end  
    ```  

3. **Empaquetar el box:**  
    ```bash  
    tar -cvzf rhel95-hyperv-local.box *  
    ```  

4. **Agregar el box localmente:**  
    ```bash  
    vagrant box add rhel95-hyperv-local rhel95-hyperv-local.box --provider=hyperv  
    ```  

5. **Probar el box:**  
    ```bash  
    vagrant init  
    vagrant up  
    ```  

---

### Subir a HashiCorp Cloud  

1. Subir el archivo `.box` creando un nuevo box desde la consola visual.  
2. Configurar:  
    - Nombre del box.  
    - Visibilidad pública.  
    - Descripción.  
    - Versionado inicial.  
    - Seleccionar el provider (ejemplo: Hyper-V).  

3. Probar el box desde la nube:  
    ```bash  
    vagrant init consulanregistry/rhel95-hyperv-cloud --box-version 0.0.1  

    Vagrant.configure("2") do |config|  
      config.vm.box = "consulanregistry/rhel95-hyperv-cloud"  
      config.vm.box_version = "0.0.1"  
    end  

    vagrant up  
    ```  
4. Grafico de virtualizacion anidada
    ```mermaid
    graph TD
        A[Host físico<br>VMWare Workstation 16]
        B[VM Windows 10<br>(Hyper-V habilitado)]
        C[VM RHEL 9.x]

        A --> B
        B --> C
    ```
