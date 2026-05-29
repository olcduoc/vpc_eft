# Changelog – terraform-aws-vpc-AUY1105-grupo-1

Todos los cambios notables en este módulo serán documentados en este archivo.
Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.0.0/).
Este proyecto adhiere a [Semantic Versioning](https://semver.org/).

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

## [1.0.1] - 2026-05-29

### Changed
- PR de revisión de código del módulo redes

## [1.0.2] - 2026-05-29

### Changed
- Revisión de código módulo redes por Juan Pablo
