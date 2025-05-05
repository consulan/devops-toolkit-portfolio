# Vagrant Configurations for HashiCorp Cloud and Hypervisors

This repository contains Vagrant configuration files for provisioning virtual machines using HashiCorp Cloud and the following hypervisors:  
- VMware Workstation  
- VirtualBox  
- KVM  
- Hyper-V  

## Prerequisites  

Before using these configurations, ensure you have the following software installed on your system:  

### General Requirements  
1. **Vagrant**: Download and install from [Vagrant's official website](https://www.vagrantup.com/).  
2. **Git**: Required to clone this repository. Install from [Git's official website](https://git-scm.com/).  

### Hypervisor-Specific Requirements  
- **VMware Workstation**: Install VMware Workstation and the Vagrant VMware plugin (`vagrant plugin install vagrant-vmware-desktop`).  
- **VirtualBox**: Install VirtualBox from [VirtualBox's official website](https://www.virtualbox.org/).  
- **KVM**: Install KVM and the `vagrant-libvirt` plugin (`vagrant plugin install vagrant-libvirt`).  
- **Hyper-V**: Ensure Hyper-V is enabled on your Windows machine.  

## Configuration  

Each hypervisor has its own Vagrantfile in this repository. Below are the configuration details:  

- **HashiCorp Cloud**:  
    - Requires a HashiCorp Cloud account and API token.  
    - Update the `Vagrantfile` with your API token.  

- **VMware Workstation**:  
    - Ensure the VMware plugin is installed.  
    - Use the `Vagrantfile.vmware` file.  

- **VirtualBox**:  
    - Use the `Vagrantfile.virtualbox` file.  

- **KVM**:  
    - Ensure `libvirt` is installed and running.  
    - View the `vagrant-box-kvm.md` doc for make the box [vagrant-box-kvm](vagrant-box-kvm.md) 

- **Hyper-V**:  
    - Use the `Vagrantfile.hyperv` file.  

## Cloning the Repository  

To clone this repository, run the following command:  

```bash  
git clone https://github.com/your-username/devops-toolkit-portfolio.git  
cd devops-toolkit-portfolio/vagrant-configurations  
```  

## Usage  

1. Navigate to the directory of the desired hypervisor:  
     ```bash  
     cd vagrant-configurations  
     ```  

2. Initialize and start the virtual machine:  
     ```bash  
     vagrant up --provider=<provider_name>  
     ```  
     Replace `<provider_name>` with the appropriate provider (e.g., `virtualbox`, `vmware_desktop`, `libvirt`, or `hyperv`).  

3. SSH into the virtual machine:  
     ```bash  
     vagrant ssh  
     ```  

4. To stop the virtual machine:  
     ```bash  
     vagrant halt  
     ```  

5. To destroy the virtual machine:  
     ```bash  
     vagrant destroy  
     ```  

## License  

This project is licensed under the MIT License.  
