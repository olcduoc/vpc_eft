# vpc_eft

## 1. Descripción

Módulo Terraform reutilizable para la creación de infraestructura de red en AWS.
Gestiona la VPC, Internet Gateway, subredes públicas y privadas (Multi-AZ), NAT Gateway,
tablas de rutas y Security Group con acceso SSH restringido.

## 2. Objetivos

- Desacoplar la lógica de red del repositorio principal para mayor reutilización.
- Parametrizar todos los recursos de red mediante variables.
- Exponer outputs estándar para integración con otros módulos.

## 3. Recursos creados

| Recurso                       | Descripción                                          |
|-------------------------------|-------------------------------------------------------|
| `aws_vpc`                     | Red privada virtual con DNS habilitado                |
| `aws_internet_gateway`        | Gateway de salida a Internet                          |
| `aws_subnet` (públicas)       | Subredes públicas con máscara /24                     |
| `aws_subnet` (privadas)       | Subredes privadas Multi-AZ *(v2.0.0)*                 |
| `aws_route_table` (pública)   | Tabla de rutas para subredes públicas                 |
| `aws_route`                   | Ruta por defecto hacia Internet                       |
| `aws_route_table_association` | Asociación subnet ↔ route table (pública y privada)   |
| `aws_eip.nat`                 | IP elástica para el NAT Gateway *(v2.0.0)*            |
| `aws_nat_gateway.main`        | NAT Gateway para salida de subredes privadas *(v2.0.0)* |
| `aws_route_table` (privada)   | Tabla de rutas con ruta por defecto al NAT GW *(v2.0.0)* |
| `aws_security_group`          | SG con SSH restringido a IP específica                |

## 4. Variables

| Variable               | Tipo           | Requerida | Descripción                                                                   |
|-------------------------|----------------|-----------|--------------------------------------------------------------------------------|
| `project_name`          | `string`       | ✅        | Nombre base para etiquetar los recursos                                       |
| `vpc_cidr`               | `string`       | ❌        | CIDR de la VPC (default: `10.1.0.0/16`)                                       |
| `public_subnet_cidrs`    | `list(string)` | ❌        | CIDRs de subredes públicas (default: `["10.1.1.0/24"]`)                       |
| `availability_zones`     | `list(string)` | ❌        | Zonas de disponibilidad (default: `["us-east-1a"]`)                           |
| `ssh_allowed_cidr`       | `string`       | ✅        | IP/CIDR autorizado para SSH. **No usar 0.0.0.0/0**                            |
| `private_subnet_cidrs`   | `list(string)` | ❌        | *(v2.0.0)* CIDRs de subredes privadas (default: `[]` → no crea subredes privadas) |
| `enable_nat_gateway`     | `bool`         | ❌        | *(v2.0.0)* Si `true`, crea NAT Gateway en la primera subred pública (default: `false`) |

## 5. Outputs

| Output               | Descripción                                                        |
|------------------------|---------------------------------------------------------------------|
| `vpc_id`               | ID de la VPC creada                                                 |
| `subnet_ids`           | Lista de IDs de las subredes públicas                               |
| `security_group_id`    | ID del Security Group con SSH restringido                           |
| `private_subnet_ids`   | *(v2.0.0)* Lista de IDs de las subredes privadas. Vacío si no se crearon |
| `nat_gateway_id`       | *(v2.0.0)* ID del NAT Gateway. `null` si `enable_nat_gateway = false` |

## 6. Instrucciones de uso

```hcl
module "redes" {
  source = "github.com/olcduoc/vpc_eft?ref=v2.0.0"

  project_name         = "EFT-OscarLeiva"
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
  enable_nat_gateway   = true
  ssh_allowed_cidr     = "TU_IP/32"
}
```

> `private_subnet_cidrs` y `enable_nat_gateway` son opcionales: si se omiten, el módulo
> se comporta igual que en `v1.x` (solo red pública), ya que ambos tienen defaults seguros
> (`[]` y `false` respectivamente).

Ver ejemplo completo en [examples/basic](./examples/basic).

## 7. Versionado

Este módulo sigue [Semantic Versioning](https://semver.org/). Ver [CHANGELOG.md](./CHANGELOG.md).

Tags publicados: `v0.1.0`, `v1.0.0`, `v2.0.0`.

---

**Integrantes:** Juan Pablo - Oscar Leiva
**Docente:** Camilo Jerez
**Institución:** Duoc UC - 2026
