



output "ws_ips" {
  value = azurerm_linux_virtual_machine.wsvm.*.public_ip_address
}
