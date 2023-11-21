variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_vm_user" {
  description = "Default users name"
  type        = string
  // No default provided, as a username is typically required
}

variable "proxmox_vm_password" {
  description = "Default users password"
  type        = string
  default     = null # Default to an empty string if no password is provided
}

variable "proxmox_vm_ssh_public_keys" {
  description = "SSH public keys"
  type        = list(string)
  default     = null # Default to an empty list if no keys are provided
}

variable "pm_tls_insecure" {
  type    = string
  default = false
}

variable "generalconfig" {
  type = object({
    bios             = string
    machine          = string
    boot_order       = list(string)
    cpu_type         = string
    network_bridge   = string
    operating_system = string
  })
  default = {
    bios             = "ovmf"    // Example default value
    machine          = "q35"     // Example default value
    boot_order       = ["scsi0"] // Example default value
    cpu_type         = "host"    // Example default value
    network_bridge   = "vmbr0"   // Example default value
    operating_system = "l26"     // Example default value
  }
}

variable "servervms" {
  type = map(
    object(
      {
        index          = number
        name           = string
        type           = string // Added type field
        desc           = string
        tags           = list(string)
        clone_target   = number
        memory         = number
        cpu_cores      = number
        datastore_id   = string //local-zfs
        disk_size      = number
        disk_interface = string
        network_bridge = string
        ip_config = object({
          address = string
          gateway = string
        })
        vlan_id       = number
        agent_enabled = bool
        agent_trim    = bool
        target_node   = string
        target_pool   = string
      }
    )
  )
  validation {
    condition     = alltrue([for vm in var.servervms : vm.type == "server" || vm.type == "client"])
    error_message = "Each server type must be either 'server' or 'client'."
  }
  default = {
    "vm1" = {
      index          = 1
      name           = "examplevm"
      desc           = "Example VM 1 Description"
      type           = "server"
      tags           = ["tag1", "tag2"]
      clone_target   = 916
      memory         = 4096
      cpu_cores      = 2
      datastore_id   = "local-zfs"
      disk_size      = "32"
      disk_interface = "scsi0"
      network_bridge = "vmbr0"
      ip_config = {
        address = "dhcp"
        gateway = null
      }
      vlan_id       = 150
      agent_enabled = true
      agent_trim    = true
      target_node   = "node1"
      target_pool   = "home"
    },
    "vm2" = {
      index          = 2
      name           = "examplevm"
      desc           = "Example VM 1 Description"
      tags           = ["tag1", "tag2"]
      type           = "server"
      clone_target   = 916
      memory         = 4096
      cpu_cores      = 2
      datastore_id   = "local-zfs"
      disk_size      = "32"
      disk_interface = "scsi0"
      network_bridge = "vmbr0"
      ip_config = {
        address = "dhcp"
        gateway = null
      }
      vlan_id       = 150
      agent_enabled = true
      agent_trim    = true
      target_node   = "node1"
      target_pool   = "home"
    },
    "vm3" = {
      index          = 3
      name           = "examplevm"
      desc           = "Example VM 1 Description"
      type           = "client"
      tags           = ["tag1", "tag2"]
      clone_target   = 916
      memory         = 4096
      cpu_cores      = 2
      datastore_id   = "local-zfs"
      disk_size      = "32"
      disk_interface = "scsi0"
      network_bridge = "vmbr0"
      ip_config = {
        address = "dhcp"
        gateway = null
      }
      vlan_id       = 150
      agent_enabled = true
      agent_trim    = true
      target_node   = "node2"
      target_pool   = "home"
    }
    // Add more VM configurations as needed
  }
}