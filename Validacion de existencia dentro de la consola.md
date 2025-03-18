

```
#!/bin/bash

# Archivos de salida para S3
S3_OUTPUT="output_s3.txt"
S3_NOT_FOUND="not_found_s3.txt"

# Limpiar archivos previos
> "$S3_OUTPUT"
> "$S3_NOT_FOUND"

# Lista de nombres de buckets según el documento "Architecture Redpack"
S3_BUCKETS=(
    "waf-portal2"
    "waf-portal"
    "waf-apiclientessap-redpack"
    "redpack-ws-elb"
    "radar-ng-ws"
    "aws-waf-logs-portal-redpack"
    "elastic-beanstalk-logs-redpack"
    "elasticbeanstalk-us-west-2-386436841319"
    "extranet-alb-redpack"
    "intercambios-lambda"
    "portal-wp"
    "radar-lib-dist"
    "backup-redpack"
    "cf-templates-wtic2w5o1udp-us-west-2"
    "cf-ws-portal"
    "db2driver"
    "ebs-java-versions"
    "athena-queries-waf"
    "aws-athena-query-results-us-west-2-386436841319"
    "aws-glue-scripts-386436841319-us-west-2"
    "aws-glue-temporary-386436841319-us-west-2"
    "aws-sam-cli-managed-default-samclisourcebucket-tnk25v41lnmb"
    "aws-waf-logs-api-redpack"
)

echo "Iniciando verificación de buckets S3..."
for BUCKET in "${S3_BUCKETS[@]}"; do
  echo "Verificando bucket S3: $BUCKET ..." | tee -a "$S3_OUTPUT"
  # Usamos head-bucket para chequear si el bucket existe.
  if aws s3api head-bucket --bucket "$BUCKET" >> "$S3_OUTPUT" 2>&1; then
      echo "Encontrado: $BUCKET" | tee -a "$S3_OUTPUT"
  else
      echo "No se encontró: $BUCKET" | tee -a "$S3_OUTPUT"
      echo "$BUCKET" >> "$S3_NOT_FOUND"
  fi
  echo "-----------------------------------------------------" | tee -a "$S3_OUTPUT"
done

echo "Verificación de buckets S3 finalizada."
echo "Resultados completos en: $S3_OUTPUT"
echo "Buckets no encontrados en: $S3_NOT_FOUND"

```