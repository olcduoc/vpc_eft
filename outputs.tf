# ─────────────────────────────────────────────────────────────
# outputs.tf  –  Módulo Redes AUY1105-grupo-1
# v2.0.0: agrega outputs de subredes privadas y NAT Gateway
# ─────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID de la VPC creada."
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "Lista de IDs de las subredes públicas."
  value       = aws_subnet.public[*].id
}

output "security_group_id" {
  description = "ID del Security Group con SSH restringido."
  value       = aws_security_group.main.id
}

# ── Outputs nuevos v2.0.0 ─────────────────────────────────────

output "private_subnet_ids" {
  description = "Lista de IDs de las subredes privadas. Vacío si no se crearon subredes privadas."
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway. Null si enable_nat_gateway = false."
  value       = length(aws_nat_gateway.main) > 0 ? aws_nat_gateway.main[0].id : null
}
