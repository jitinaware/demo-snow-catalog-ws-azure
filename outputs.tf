



output "Web Server Public IPs" {
  value = azurerm_linux_virtual_machine.wsvm.*.public_ip_address
}
