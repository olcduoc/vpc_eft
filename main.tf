# ─────────────────────────────────────────────────────────────
# main.tf  –  Módulo Redes AUY1105-grupo-1
# v2.1.0: refactor de subredes de count a for_each/locals
#         (IE4.2.1 — optimización: elimina duplicación, escala
#         a N zonas de disponibilidad sin tocar código)
# ─────────────────────────────────────────────────────────────

# ── Locals: mapea cada CIDR a su AZ correspondiente ───────────
locals {
  public_subnets = {
    for idx, cidr in var.public_subnet_cidrs :
    tostring(idx) => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }

  private_subnets = {
    for idx, cidr in var.private_subnet_cidrs :
    tostring(idx) => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }
}

# ── VPC ───────────────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

# ── Internet Gateway ──────────────────────────────────────────
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

# ── Subredes PÚBLICAS (optimizado con for_each) ───────────────
resource "aws_subnet" "public" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-subnet-public-${tonumber(each.key) + 1}"
    Project = var.project_name
    Type    = "public"
  }
}

# ── Route Table PÚBLICA ───────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-rt-public"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ── Security Group ────────────────────────────────────────────
resource "aws_security_group" "main" {
  name        = "${var.project_name}-sg"
  description = "SSH restringido a IP autorizada"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH desde IP autorizada"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Todo el trafico saliente permitido"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}

# ── Subredes PRIVADAS (optimizado con for_each) ───────────────
resource "aws_subnet" "private" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name    = "${var.project_name}-subnet-private-${tonumber(each.key) + 1}"
    Project = var.project_name
    Type    = "private"
  }
}

# ── EIP + NAT Gateway ──────────────────────────────────────────
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name    = "${var.project_name}-nat-eip"
    Project = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public["0"].id

  tags = {
    Name    = "${var.project_name}-nat-gw"
    Project = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

# ── Route Table PRIVADA ────────────────────────────────────────
resource "aws_route_table" "private" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }

  tags = {
    Name    = "${var.project_name}-rt-private"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "private" {
  for_each       = var.enable_nat_gateway ? aws_subnet.private : {}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}
