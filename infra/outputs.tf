output "alb_url" {
  description = "URL publique de l Application Load Balancer a tester dans le navigateur"
  value       = "http://${module.compute.alb_dns_name}"
}

output "first_instance_private_ip" {
  description = "IP privee de l instance applicative (aucune IP publique)"
  value       = module.compute.first_instance_ip
}

output "nat_gateway_ip" {
  description = "IP publique fixe de la NAT Gateway (doit correspondre a celle vue sur la page web)"
  value       = module.network.nat_gateway_ip
}
