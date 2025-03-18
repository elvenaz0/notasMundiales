


```
#!/bin/bash

# Archivos de salida
OUTPUT="output_rds.txt"
NOT_FOUND="not_found_rds.txt"

# Limpiar archivos previos
> "$OUTPUT"
> "$NOT_FOUND"

# Lista de identificadores (nombre de RDS) a verificar
RDS_INSTANCES=(
  "a2-rds"
  "amazon"
  "db-a2-prod"
  "db-clasifica"
  "db-clasifica-prod"
  "db-landings-prod"
  "db-landings-qa"
  "db-sefacture"
  "db-sefactureqa"
  "portalweb-qa"
  "redpost"
  "redpostdbrep"
  "db-portalwordpress-dev"
  "db-portalwordpress-prod"
  "vtiger"
  "vtigerdbrep"
)

# Recorrer la lista y verificar cada instancia RDS
for IDENTIFIER in "${RDS_INSTANCES[@]}"; do
  echo "Verificando instancia RDS con identifier=$IDENTIFIER ..." | tee -a "$OUTPUT"
  
  # Ejecutar el comando para describir la instancia RDS
  if aws rds describe-db-instances --db-instance-identifier "$IDENTIFIER" >> "$OUTPUT" 2>&1; then
      echo "Encontrada: $IDENTIFIER" | tee -a "$OUTPUT"
  else
      echo "No se encontró: $IDENTIFIER" | tee -a "$OUTPUT"
      echo "$IDENTIFIER" >> "$NOT_FOUND"
  fi
  
  echo "-----------------------------------------------------" | tee -a "$OUTPUT"
done

echo "Verificación finalizada."
echo "La salida completa se ha guardado en $OUTPUT"
echo "Las instancias no encontradas se listan en $NOT_FOUND"

```