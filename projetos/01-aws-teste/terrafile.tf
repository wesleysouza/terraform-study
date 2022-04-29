module "servers" {
  source  = "./servers"
  servers = 1
}

output "dns_name" {
  value = module.servers.ip_address
}

output "ip_address" {
  value = module.servers.dns_name
}