

---
# todo en uno en JSON



```
#!/bin/bash

OUTPUT="aws_full_resource_list.json"
# Limpiar el archivo de salida previo
> "$OUTPUT"

echo "{" > "$OUTPUT"

echo "  \"EC2_Instances\": " >> "$OUTPUT"
aws ec2 describe-instances --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"RDS_Instances\": " >> "$OUTPUT"
aws rds describe-db-instances --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"Classic_ELB\": " >> "$OUTPUT"
aws elb describe-load-balancers --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"ELBv2\": " >> "$OUTPUT"
aws elbv2 describe-load-balancers --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"S3_Buckets\": " >> "$OUTPUT"
aws s3api list-buckets --query "Buckets[].Name" --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"VPCs\": " >> "$OUTPUT"
aws ec2 describe-vpcs --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"Subnets\": " >> "$OUTPUT"
aws ec2 describe-subnets --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"Security_Groups\": " >> "$OUTPUT"
aws ec2 describe-security-groups --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"Lambda_Functions\": " >> "$OUTPUT"
aws lambda list-functions --output json >> "$OUTPUT"
echo "," >> "$OUTPUT"

echo "  \"CloudFront_Distributions\": " >> "$OUTPUT"
aws cloudfront list-distributions --output json >> "$OUTPUT"

echo "}" >> "$OUTPUT"

echo "Listado completo de recursos AWS guardado en $OUTPUT"

```



---



```
#!/bin/bash

OUTPUT="aws_full_resource_list.txt"
# Limpiar el archivo de salida previo
> "$OUTPUT"

echo "===== Listado de recursos AWS =====" | tee -a "$OUTPUT"

echo "===== 1. Instancias EC2 =====" | tee -a "$OUTPUT"
aws ec2 describe-instances --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 2. Instancias RDS =====" | tee -a "$OUTPUT"
aws rds describe-db-instances --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 3. Classic ELB =====" | tee -a "$OUTPUT"
aws elb describe-load-balancers --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 4. ELBv2 (ALB/NLB) =====" | tee -a "$OUTPUT"
aws elbv2 describe-load-balancers --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 5. Buckets S3 =====" | tee -a "$OUTPUT"
aws s3api list-buckets --query "Buckets[].Name" --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 6. VPCs =====" | tee -a "$OUTPUT"
aws ec2 describe-vpcs --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 7. Subnets =====" | tee -a "$OUTPUT"
aws ec2 describe-subnets --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 8. Security Groups =====" | tee -a "$OUTPUT"
aws ec2 describe-security-groups --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 9. Funciones AWS Lambda =====" | tee -a "$OUTPUT"
aws lambda list-functions --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== 10. Distribuciones CloudFront =====" | tee -a "$OUTPUT"
aws cloudfront list-distributions --output table | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "===== Listado completo de recursos AWS finalizado =====" | tee -a "$OUTPUT"

```



---

```
#!/bin/bash

##############################
# PARTE 1: Validar instancias EC2
##############################

# Archivos de salida para EC2
EC2_OUTPUT="output_ec2.txt"
EC2_NOT_FOUND="not_found_ec2.txt"

# Limpiar archivos previos
> "$EC2_OUTPUT"
> "$EC2_NOT_FOUND"

# Lista de nombres (valor de la etiqueta "Name") a verificar para EC2
EC2_INSTANCES=(
  "DB2_DEV"
  "Zimbra"
  "iTop"
  "Pentaho"
  "Barracuda"
  "SVN"
  "CSR"
  "Sefacture"
  "Intranet"
  "DB2_PROD"
  "Interfaces"
  "WAS_Prod"
  "Update"
  "Extranet"
  "Extranet-QA"
  "WAS-QA"
  "Nagios"
  "Procesos"
  "Amazon"
  "CSR_QA"
  "SefactureQA"
  "iTop-SuccessFactor"
  "Kaspersky"
  "Portalwp-env"
  "Clasificacion2prod"
  "RedpackWS-CM"
  "RedpackWS-WS"
  "Amazona2-env"
  "ccrpkprod-env"
  "Chato-Codex"
  "Intercambios-Tracking-Prod"
  "TestCodex"
  "TestCodexRpk-env-2"
  "Testtracking-env"
  "Redpost"
  "Redpost-QA"
  "ClasificacionProd"
  "RedpackAPI3"
  "Clasificacion3prod"
  "RedpackAPI2"
  "RedpackWS-WP"
  "RedpackWS-QA"
  "RedpackAPI"
  "DB2_Exports"
  "AD-VPN"
  "vTiger"
  "Redpackwordpress6-env"
  "Coberturasprod-env-1"
  "TestCCRpk"
  "testradar-ng"
  "TestCoberturas"
  "DB2_QA"
  "Redpackrestservices2-env-1"
  "Redpackrestservices2-env-b-1"
  "Redpackrestservices2-env-c-1"
  "ClasificacionDev"
  "Clasificacion3Dev"
  "Clasificacion2Dev"
  "Test"
)

echo "Iniciando verificación de instancias EC2..."
for NAME in "${EC2_INSTANCES[@]}"; do
  echo "Verificando instancia EC2 con Name=$NAME ..." | tee -a "$EC2_OUTPUT"
  # Se consulta usando el filtro por etiqueta Name.
  if aws ec2 describe-instances --filters "Name=tag:Name,Values=$NAME" >> "$EC2_OUTPUT" 2>&1; then
      # Se asume que si el comando retorna un JSON sin error, la instancia fue encontrada.
      # (Nota: Si la salida es vacía, se puede interpretar como que no hay coincidencia.)
      RESULT=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$NAME" --query 'Reservations[].Instances' --output text)
      if [ -z "$RESULT" ]; then
         echo "No se encontró: $NAME" | tee -a "$EC2_OUTPUT"
         echo "$NAME" >> "$EC2_NOT_FOUND"
      else
         echo "Encontrada: $NAME" | tee -a "$EC2_OUTPUT"
      fi
  else
      echo "No se encontró: $NAME" | tee -a "$EC2_OUTPUT"
      echo "$NAME" >> "$EC2_NOT_FOUND"
  fi
  echo "-----------------------------------------------------" | tee -a "$EC2_OUTPUT"
done

echo "Verificación de instancias EC2 finalizada."
echo "Resultados completos en: $EC2_OUTPUT"
echo "Instancias no encontradas en: $EC2_NOT_FOUND"


##############################
# PARTE 2: Validar contenedores Elastic Beanstalk (Entornos)
##############################

# Archivos de salida para EB
EB_OUTPUT="output_eb.txt"
EB_NOT_FOUND="not_found_eb.txt"

# Limpiar archivos previos
> "$EB_OUTPUT"
> "$EB_NOT_FOUND"

# Lista de nombres de entornos Elastic Beanstalk a verificar.
# Reemplaza estos valores por los nombres reales de tus entornos EB.
EB_CONTAINERS=(
  "Redpack-EB-Container-A"
  "Redpack-EB-Container-B"
)

echo ""
echo "Iniciando verificación de entornos Elastic Beanstalk..."
for NAME in "${EB_CONTAINERS[@]}"; do
  echo "Verificando Elastic Beanstalk Container con Environment Name=$NAME ..." | tee -a "$EB_OUTPUT"
  # Se consulta el entorno EB
  EB_RESPONSE=$(aws elasticbeanstalk describe-environments --environment-names "$NAME" --query "Environments" --output text 2>&1)
  if [ -z "$EB_RESPONSE" ] || [[ "$EB_RESPONSE" == "None" ]]; then
      echo "No se encontró: $NAME" | tee -a "$EB_OUTPUT"
      echo "$NAME" >> "$EB_NOT_FOUND"
  else
      echo "Encontrada: $NAME" | tee -a "$EB_OUTPUT"
  fi
  echo "-----------------------------------------------------" | tee -a "$EB_OUTPUT"
done

echo "Verificación de Elastic Beanstalk Containers finalizada."
echo "Resultados completos en: $EB_OUTPUT"
echo "Entornos no encontrados en: $EB_NOT_FOUND"

```