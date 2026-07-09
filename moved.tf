# ─────────────────────────────────────────────────────────────
# moved.tf  –  Módulo Redes AUY1105-grupo-1
# Migración de direcciones de state: count -> for_each (v2.1.0)
#
# IMPORTANTE: sin estos bloques, "terraform plan" mostraría
# destrucción y recreación de TODOS los recursos de red ya
# desplegados, ya que cambian de índice de lista ([0], [1]) a
# clave de mapa (["0"], ["1"]). Estos bloques le indican a
# Terraform que es el MISMO recurso, solo con nueva dirección.
#
# Ajustar el rango según la cantidad real de subredes desplegadas
# (aquí se cubren 2 públicas y 2 privadas, según la arquitectura
# Multi-AZ actual: us-east-1a / us-east-1b).
# ─────────────────────────────────────────────────────────────

moved {
  from = aws_subnet.public[0]
  to   = aws_subnet.public["0"]
}

moved {
  from = aws_subnet.public[1]
  to   = aws_subnet.public["1"]
}

moved {
  from = aws_subnet.private[0]
  to   = aws_subnet.private["0"]
}

moved {
  from = aws_subnet.private[1]
  to   = aws_subnet.private["1"]
}

moved {
  from = aws_route_table_association.public[0]
  to   = aws_route_table_association.public["0"]
}

moved {
  from = aws_route_table_association.public[1]
  to   = aws_route_table_association.public["1"]
}

moved {
  from = aws_route_table_association.private[0]
  to   = aws_route_table_association.private["0"]
}

moved {
  from = aws_route_table_association.private[1]
  to   = aws_route_table_association.private["1"]
}
