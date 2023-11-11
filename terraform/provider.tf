# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

provider "proxmox" {
  pm_debug            = var.pm_debug
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  # (Optional) Skip TLS Verification
  pm_tls_insecure = var.pm_tls_insecure

}