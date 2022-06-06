module "simple-lab" {
  source = "./simple-lab"
  #parâmetros
}

output "ip_address" {
  value = module.simple-lab.ip_address
}

output "dns_name" {
  value = module.simple-lab.dns_name
}