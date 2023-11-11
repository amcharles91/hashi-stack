variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

variable "proxmox_ssh_user" {
  type = string
}

variable "proxmox_ssh_private_key" {
  type = string
}

variable "pm_tls_insecure" {
  type    = string
  default = false
}

variable "pm_debug" {
  type    = bool
  default = true
}

variable "servervms" {
  type = map(
    object(
      {
        index          = number
        name           = string
        target_node    = string
        target_pool    = string
        clone_target   = string
        desc           = string
        os_type        = string
        qemu_os        = string
        ipconfig       = string
        memory         = number
        memory_min     = number
        onboot         = bool
        cloud_drive    = string
        agent          = number
        disk_create    = bool
        disk_datastore = string
        disk_size      = string
        disk_type      = string
        disk_format    = string
        disk_ssd       = number
        cores          = number
        network_bridge = string
      }
    )
  )
}

variable "clientvms" {
  type = map(
    object(
      {
        index          = number
        name           = string
        target_node    = string
        target_pool    = string
        clone_target   = string
        desc           = string
        os_type        = string
        qemu_os        = string
        ipconfig       = string
        memory         = number
        memory_min     = number
        onboot         = bool
        agent          = number
        cloud_drive    = string
        disk_create    = bool
        disk_datastore = string
        disk_size      = string
        disk_type      = string
        disk_format    = string
        disk_ssd       = number
        cores          = number
        network_bridge = string
      }
    )
  )
}