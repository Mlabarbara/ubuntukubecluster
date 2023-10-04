terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}
# provider is the infrastructer that we will be building on; in this case it is my r630 proxmox server
provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_token_id = var.pm_token_id
  pm_token_secret = var.pm_token_secret
  pm_tls_insecure = true
}

# now we start to define the resources that we want to build
# the resource name I believe is defined in the provider so it has to be proxmox_vm_qemu
resource "proxmox_vm_qemu" "kube-server" {
  count = 1
  name = "kuber-server-0${count.index + 1}"
  target_node = "r630-pve"
  vmid = "100${count.index + 1}"

  clone = "ubuntu-2004-cloudinit-template"
  full_clone = true
  
  agent = 1
  os_type = "cloud-init"
  cores = 4
  socket = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-single"
  bootsidk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "nvme001"
    iothread = 1
    discard = "yes"
    ssd = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
  ipconfig0 = "ip=192.168.10${count.index + 1}.${count.index + 1}/16,gw=192.168.10.1"
  ipconfig1 = "ip=10.10.10.1${count.index + 1}/24" 

  sshkeys= var.ssh_key
}
resource "proxmox_vm_qemu" "kube-node" {
  count = 2
  name = "kube-node-0${count.index + 1}"
  target_node = "r630-pve"
  vmid = "101${count.index + 1}"

  clone = "ubuntu-2004-cloudinit-template"
  full_clone = true
  agent = 1
  os_type = "cloud-int"
  cores = 2
  cpu = "host"
  memory = 2048
  socket = 1
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "nvme002"
    iothread = 1
    discard = "yes"
    ssd = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  network {
    model = "virtio"
    bridge = "vmbr1"
  }

  ipconfig0 = "ip=192.168.2${count.index + 1}.10${count.index + 1}/16,gw=192.168.10.1"
  ipconfig1 = "ip=10.10.10.2${count.index + 1}/24"

  
}