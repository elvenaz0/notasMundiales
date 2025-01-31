# Documentación: Obtención de IDs de Hosted Zones en AWS Route 53

## Introducción

Este documento detalla los pasos necesarios para obtener los IDs de las Hosted Zones en AWS Route 53 utilizando únicamente la línea de comandos de AWS CLI.

---

## Prerrequisitos

1. Tener configurado AWS CLI en tu sistema. Si no lo has hecho, sigue estos pasos:
    
    ```bash
    aws configure
    ```
    
    Proporciona los valores para:
    
    - Access Key ID
    - Secret Access Key
    - Región por defecto
    - Formato de salida (se recomienda JSON o table).
2. Contar con permisos necesarios en IAM para listar las Hosted Zones en Route 53:
    
    - `route53:ListHostedZones`

---

## Pasos para obtener los IDs de las Hosted Zones

1. **Ejecutar el comando para listar todas las Hosted Zones:**
    
    ```bash
    aws route53 list-hosted-zones
    ```
    
    Este comando devuelve un listado en formato JSON con información sobre las Hosted Zones, incluyendo sus nombres y IDs.
    
2. **Filtrar los IDs de las Hosted Zones:** Para extraer únicamente los IDs de las Hosted Zones, utiliza el parámetro `--query` junto con un filtro:
    
    ```bash
    aws route53 list-hosted-zones --query "HostedZones[].Id" --output text
    ```
    
    Este comando devolverá únicamente los IDs en un formato limpio, por ejemplo:
    
    ```
    /hostedzone/ZF41A0NTKGTRB
    /hostedzone/ZDQ58BLKKWPI2
    /hostedzone/Z3OYSQ9WMEZAKQ
    ```
    
3. **Formatear los resultados eliminando el prefijo `/hostedzone/`:** Si deseas obtener los IDs sin el prefijo, puedes procesar la salida con herramientas como `sed`:
    
    ```bash
    aws route53 list-hosted-zones --query "HostedZones[].Id" --output text | sed 's|/hostedzone/||g'
    ```
    
    Resultado esperado:
    
    ```
    ZF41A0NTKGTRB
    ZDQ58BLKKWPI2
    Z3OYSQ9WMEZAKQ
    ```
    
4. **Obtener información adicional de cada Hosted Zone (opcional):** Si necesitas más detalles, puedes listar todas las Hosted Zones con sus nombres, IDs y otros atributos:
    
    ```bash
    aws route53 list-hosted-zones --query "HostedZones[].{Name:Name, ID:Id, Type:Config.PrivateZone}" --output table
    ```
    
    Esto generará una tabla con información legible.
    

---

## Ejemplo de uso

### Listar todos los IDs de Hosted Zones:

```bash
aws route53 list-hosted-zones --query "HostedZones[].Id" --output text
```

Resultado:

```bash
/hostedzone/ZF41A0NTKGTRB
/hostedzone/ZDQ58BLKKWPI2
/hostedzone/Z3OYSQ9WMEZAKQ
```

### Listar IDs sin prefijo:

```bash
aws route53 list-hosted-zones --query "HostedZones[].Id" --output text | sed 's|/hostedzone/||g'
```

Resultado:

```bash
ZF41A0NTKGTRB
ZDQ58BLKKWPI2
Z3OYSQ9WMEZAKQ
```

---

## Notas adicionales

- El prefijo `/hostedzone/` es parte del formato de salida de la API de AWS y puede ser útil si necesitas interactuar con otras herramientas que lo requieran.
- Puedes cambiar el formato de salida con el parámetro `--output`. Los formatos disponibles son `json`, `text`, y `table`.

---

## Recursos adicionales

- [Documentación oficial de AWS CLI - Route 53](https://docs.aws.amazon.com/cli/latest/reference/route53/index.html)
- [Filtrado de salida en AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html)