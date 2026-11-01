output "activegate_public_ip" {
  description = "Public IP of the ActiveGate VM"
  value       = azurerm_public_ip.activegate.ip_address
}

output "activegate_fqdn" {
  description = "FQDN of the ActiveGate VM (use this in Dynatrace)"
  value       = azurerm_public_ip.activegate.fqdn
}