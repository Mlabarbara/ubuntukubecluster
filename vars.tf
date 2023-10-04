variable "pm_api_url" {
  description = "This is the URL to the proxmox server"
}
variable "pm_token_id" {
  description = "This is the token ID for the user that has permissions to create VMs, etc..."
}
variable "pm_token_secret" {
  description = "This is the token secret for said user"
}
variable "ssh_key" {
  description = "The ssh keys that will be loaded onto the machines"
}