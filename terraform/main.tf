# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "servers" {
  for_each = var.servervms
  # VM General Settings
  target_node = each.value.target_node
  name        = "${each.value.name}0${each.value.index}"
  desc        = each.value.desc
  pool        = each.value.target_pool
  # VM Advanced General Settings
  onboot           = each.value.onboot
  full_clone       = false
  automatic_reboot = true
  qemu_os          = "l26"
  #bootdisk         = "scsi0"
  #preprovision = false
  cloudinit_cdrom_storage = each.value.cloud_drive

  # force_create = true
  additional_wait = 10
  # VM OS Settings
  clone   = each.value.clone_target
  bios    = "ovmf"
  os_type = each.value.os_type
  # VM System Settings
  agent = each.value.agent

  # VM CPU Settings
  cores   = each.value.cores
  sockets = 1
  cpu     = "host"

  # VM Memory Settings
  memory  = each.value.memory
  balloon = each.value.memory_min

  # VM Network Settings
  network {
    bridge = each.value.network_bridge
    model  = "virtio"
  }

  # VM Disk
  scsihw = "virtio-scsi-pci"

  dynamic "disk" {
    for_each = each.value.disk_create ? [1] : []
    content {
      size    = each.value.disk_size
      storage = each.value.disk_datastore
      type    = each.value.disk_type
      format  = each.value.disk_format
      ssd     = each.value.disk_ssd
    }
  }
  
  # VM Cloud-Init Settings
  ipconfig0 = each.value.ipconfig

  # Life cycle ignores
  lifecycle {
    ignore_changes = [
      network
    ]
  }

}

resource "proxmox_vm_qemu" "clients" {
  for_each = var.clientvms
  # VM General Settings
  target_node = each.value.target_node
  name        = "${each.value.name}0${each.value.index}"
  desc        = each.value.desc
  pool        = each.value.target_pool
  # VM Advanced General Settings
  onboot           = each.value.onboot
  full_clone       = false
  automatic_reboot = true
  qemu_os          = "l26"
  #bootdisk         = "scsi0"
  #preprovision = false
  cloudinit_cdrom_storage = each.value.cloud_drive

  # force_create = true
  additional_wait = 10
  # VM OS Settings
  clone   = each.value.clone_target
  bios    = "ovmf"
  os_type = each.value.os_type
  # VM System Settings
  agent = each.value.agent

  # VM CPU Settings
  cores   = each.value.cores
  sockets = 1
  cpu     = "host"

  # VM Memory Settings
  memory  = each.value.memory
  balloon = each.value.memory_min

  # VM Network Settings
  network {
    bridge = each.value.network_bridge
    model  = "virtio"
  }

  # VM Disk
  scsihw = "virtio-scsi-pci"

  dynamic "disk" {
    for_each = each.value.disk_create ? [1] : []
    content {
      size    = each.value.disk_size
      storage = each.value.disk_datastore
      type    = each.value.disk_type
      format  = each.value.disk_format
      ssd     = each.value.disk_ssd
    }
  }

  # VM Cloud-Init Settings
  ipconfig0 = each.value.ipconfig

  # Life cycle ignores
  lifecycle {
    ignore_changes = [
      network
    ]
  }

}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      servers = tomap({
        for instance in proxmox_vm_qemu.servers :
        instance.name => instance.default_ipv4_address
      })
      clients = tomap({
        for instance in proxmox_vm_qemu.clients :
        instance.name => instance.default_ipv4_address
      })
    }
  )
  filename = "${path.module}/inventory"
}
