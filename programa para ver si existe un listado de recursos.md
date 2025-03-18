

```
#!/bin/bash

# Archivo donde se guardará la salida
OUTPUT="output.txt"
# Se limpia el contenido previo del archivo
> "$OUTPUT"

INSTANCIAS=(
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

for NAME in "${INSTANCIAS[@]}"; do
  echo "Verificando instancia EC2 con Name=$NAME ..." | tee -a "$OUTPUT"
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$NAME" | tee -a "$OUTPUT"
  echo "-----------------------------------------------------" | tee -a "$OUTPUT"
done

```