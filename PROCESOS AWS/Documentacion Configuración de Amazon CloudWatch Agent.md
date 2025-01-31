## Introducción

En este documento se detallan los pasos seguidos para configurar y activar el **Amazon CloudWatch Agent** en varias instancias EC2 utilizando **AWS Systems Manager (SSM)** y la línea de comandos en **AWS CloudShell**.

---

## Pasos Realizados

### 1. Crear el Archivo de Configuración JSON

#### Contenido del Archivo `amazon-cloudwatch-agent.json`:

```json
{
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": ["mem_used_percent", "mem_available"]
      }
    }
  }
}
```

#### Explicación:

Este archivo define las métricas que el agente recopilará, enfocándose en el uso de memoria.

---

### 2. Subir el Archivo JSON a S3

#### Comando:

```bash
aws s3 cp amazon-cloudwatch-agent.json s3://s3temporalram/amazon-cloudwatch-agent.json
```

#### Explicación:

El archivo se sube a un bucket S3 accesible para que las instancias EC2 puedan descargarlo.

---

### 3. Verificación de SSM Agent en las Instancias

#### Comando:

```bash
aws ec2 describe-instances --instance-ids <instance-id> --query 'Reservations[*].Instances[*].State.Name'
```

#### Explicación:

Se verificó que las instancias estuvieran en estado **Running** y que tuvieran el **SSM Agent** configurado para aceptar comandos remotos.

---

### 4. Eliminación del Directorio Incorrecto

#### Comando:

```bash
rm -rf /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

#### Explicación:

En algunas instancias, se había creado un directorio en lugar del archivo JSON de configuración. Este comando eliminó el directorio incorrecto.

---

### 5. Descarga del Archivo JSON desde S3

#### Comando:

```bash
aws s3 cp s3://s3temporalram/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

#### Explicación:

Se descargó el archivo de configuración **amazon-cloudwatch-agent.json** desde el bucket **s3temporalram** y se colocó en la ruta correcta en las instancias EC2.

---

### 6. Validación y Aplicación de la Configuración

#### Comando:

```bash
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
```

#### Explicación:

Este comando validó y aplicó la configuración del agente usando el archivo JSON descargado.

---

### 7. Reinicio del Amazon CloudWatch Agent

#### Comando:

```bash
sudo systemctl restart amazon-cloudwatch-agent
sudo systemctl status amazon-cloudwatch-agent
```

#### Explicación:

Se reinició el servicio para aplicar los cambios y se verificó que estuviera funcionando correctamente.

---

### 8. Ejecución de los Comandos en Varias Instancias

#### Script Completo:

```bash
for instance_id in i-06497fbfdac397962 i-0cde5a65053f5b35f i-01792c9ab2d4f51a1 i-0c3c8b45e7a323e50 i-0d75e18ae575f83a2 i-069e6469e4db01e42 i-02eee047a45e37f8b i-06730da1885392f9b i-06393fdb3dd9e89c0 i-042a7addb6b7cea4f i-07f6acaac1222be9e i-09f96ed0fc8e9460d i-069489c661f7036e7 i-03902112934548d45
do
  echo "Configurando instancia: $instance_id"
  aws ssm send-command \
    --instance-ids $instance_id \
    --document-name "AWS-RunShellScript" \
    --comment "Configurar Amazon CloudWatch Agent" \
    --parameters 'commands=[
      "rm -rf /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json",
      "aws s3 cp s3://s3temporalram/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json",
      "/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s",
      "sudo systemctl restart amazon-cloudwatch-agent",
      "sudo systemctl status amazon-cloudwatch-agent"
    ]' \
    --region us-west-2
done
```

#### Explicación:

Este script iteró sobre todas las instancias para realizar los pasos mencionados de forma automática en cada una.

---

## Verificación Final

Para verificar que el agente estuviera funcionando correctamente, se revisaron los logs:

#### Comando:

```bash
cat /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```

---

## Conclusión

Estos pasos aseguraron la correcta configuración y funcionamiento del **Amazon CloudWatch Agent** en todas las instancias EC2, permitiendo el monitoreo de métricas como el uso de memoria RAM.