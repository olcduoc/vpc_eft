# ─────────────────────────────────────────────────────────────
# outputs.tf  –  Módulo Redes AUY1105-grupo-1
# v2.1.0: adaptado a subredes for_each (ver main.tf)
#         Los outputs mantienen el mismo tipo y orden que en v2.0.0
#         (list(string), ordenados por índice) para no romper
#         la interfaz que consume root_eft.
# ─────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID de la VPC creada."
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "Lista de IDs de las subredes públicas, en el mismo orden que public_subnet_cidrs."
  value       = [for k in sort(keys(aws_subnet.public)) : aws_subnet.public[k].id]
}

output "security_group_id" {
  description = "ID del Security Group con SSH restringido."
  value       = aws_security_group.main.id
}

# ── Outputs v2.0.0 ────────────────────────────────────────────

output "private_subnet_ids" {
  description = "Lista de IDs de las subredes privadas, en el mismo orden que private_subnet_cidrs. Vacío si no se crearon subredes privadas."
  value       = [for k in sort(keys(aws_subnet.private)) : aws_subnet.private[k].id]
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway. Null si enable_nat_gateway = false."
  value       = length(aws_nat_gateway.main) > 0 ? aws_nat_gateway.main[0].id : null
}
