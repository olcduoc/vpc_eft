# Changelog – vpc_eft

Todos los cambios notables en este módulo serán documentados en este archivo.
Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).
Este proyecto adhiere a [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-06-29

### Added
- Variable `private_subnet_cidrs` (`list(string)`, default: `[]`) para definir subredes privadas.
- Variable `enable_nat_gateway` (`bool`, default: `false`) para habilitar NAT Gateway.
- Recurso `aws_subnet.private` con soporte Multi-AZ mediante `count`.
- Recurso `aws_eip.nat` para la IP elástica del NAT Gateway.
- Recurso `aws_nat_gateway.main` para tráfico saliente desde subredes privadas.
- Recurso `aws_route_table.private` con ruta por defecto hacia el NAT Gateway.
- Recurso `aws_route_table_association.private` para asociar subredes privadas a la route table.
- Output `private_subnet_ids`: IDs de las subredes privadas creadas.
- Output `nat_gateway_id`: ID del NAT Gateway (`null` si no está habilitado).

### Changed
- Etiqueta `Type` agregada a las subredes públicas (`"public"`) y privadas (`"private"`).
- `depends_on` en EIP y NAT Gateway para garantizar orden de creación con el IGW.
- Revisión de código del módulo de redes (PR `feat/jp-revision-modulo-vpc`, por Juan Pablo).
- Segunda revisión de código del módulo de redes (PR `feat/jp-revision-vpc-v2`, por Juan Pablo).
- README.md actualizado con nuevas variables, outputs y ejemplo Multi-AZ.

### Migration Guide (v1.x → v2.0.0)
Esta versión es **retrocompatible**: si no se pasan `private_subnet_cidrs` ni
`enable_nat_gateway`, el comportamiento es idéntico a v1.x. El output `subnet_ids`
(subredes públicas) **no cambió de nombre** — se mantiene igual que en v1.x. No se
requieren cambios en configuraciones existentes que no usen subredes privadas.

## [1.0.0] - 2026-05-28

### Added
- Módulo inicial de redes extraído del repositorio principal AUY1105-GRUPO-Nro1.
- Recurso `aws_vpc` parametrizado con variable `vpc_cidr`.
- Recurso `aws_internet_gateway` asociado a la VPC.
- Recurso `aws_subnet` con soporte para múltiples subredes públicas mediante `count`.
- Recursos `aws_route_table`, `aws_route` y `aws_route_table_association`.
- Recurso `aws_security_group` con acceso SSH restringido a IP específica.
- Outputs: `vpc_id`, `subnet_ids`, `security_group_id`.
- Archivo `versions.tf` con restricción Terraform `>= 1.5.0` y AWS provider `~> 5.0`.
- Carpeta `examples/basic` con ejemplo funcional de uso del módulo.
- Documentación completa en `README.md`.

## [0.1.0] - 2026-05-28

### Added
- Estructura inicial del repositorio del módulo.
- Archivos base: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`.
- Archivo `.gitignore` para excluir archivos temporales de Terraform.
