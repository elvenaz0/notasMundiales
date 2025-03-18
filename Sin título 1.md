A continuación, te incluyo un texto completo que puedes copiar y pegar en un editor de tu preferencia (Word, Google Docs, etc.) y luego **exportar** o **imprimir como PDF**. Así tendrás un documento ordenado con toda la explicación.

---

# Documento: Problema de Redirección en “sqaws.ieem.org.mx/siucs”

**Objetivo**  
Explicar por qué la ruta `sqaws.ieem.org.mx/siucs` no funciona de la misma forma que `http://54.226.135.201/siucs` y `http://18.209.62.127/siucs`, y cómo verificar la configuración de AWS (Route53, ALB, CloudFront) para corregirlo.

---

## 1. Antecedentes

Se cuenta con un dominio `sqaws.ieem.org.mx` el cual se espera que sirva la aplicación “SIUCS” en la ruta `/siucs`. Sin embargo, se detectó que ingresar a `sqaws.ieem.org.mx/siucs` **no** redirige correctamente, mientras que las IPs directas `54.226.135.201/siucs` y `18.209.62.127/siucs` sí muestran la aplicación.

Se sospecha que el tráfico hacia el dominio está pasando por un balanceador (o un CDN) que no está configurado para redirigir a la misma instancia o ALB que sirve la aplicación “SIUCS”.

---

## 2. Revisión de la configuración en AWS

### 2.1 Route53 (DNS)

Al inspeccionar **`route53_records.json`**, se encuentra lo siguiente para `sqaws.ieem.org.mx`:

```json
{
  "Name": "sqaws.ieem.org.mx.",
  "Type": "A",
  "AliasTarget": {
    "HostedZoneId": "Z2FDTNDATAQYW2",
    "DNSName": "d3qaxn8vc1rt6w.cloudfront.net.",
    "EvaluateTargetHealth": false
  }
}
```

Esto confirma que el subdominio **`sqaws.ieem.org.mx` apunta a una distribución de CloudFront** (dominio `d3qaxn8vc1rt6w.cloudfront.net`), **no** a un Load Balancer de tipo ALB directamente.

### 2.2 CloudFront

En el archivo **`cloudfront_list.json`** se identifica la distribución con el dominio `d3qaxn8vc1rt6w.cloudfront.net`. Esta es la responsable de recibir peticiones a `sqaws.ieem.org.mx`. Se observa:

```json
{
  "Id": "E3BTFAN3RDII2S",
  "DomainName": "d3qaxn8vc1rt6w.cloudfront.net",
  "Aliases": {
    "Items": ["sqaws.ieem.org.mx"]
  },
  "Origins": {
    "Items": [
      {
        "Id": "ALB-IEEM-Dev-405231709.us-east-1.elb.amazonaws.com",
        "DomainName": "dev-alb.ieem.org.mx",
        ...
      }
    ]
  },
  ...
}
```

Por lo tanto, la distribución de CloudFront `E3BTFAN3RDII2S` atiende las solicitudes entrantes y las redirige a un “origen” llamado `dev-alb.ieem.org.mx`.

### 2.3 ALB: “dev-alb.ieem.org.mx”

Al verificar en **`route53_records.json`** existe:

```json
{
  "Name": "dev-alb.ieem.org.mx.",
  "Type": "A",
  "AliasTarget": {
    "HostedZoneId": "Z35SXDOTRQ7X7K",
    "DNSName": "dualstack.alb-ieem-dev-405231709.us-east-1.elb.amazonaws.com.",
    "EvaluateTargetHealth": true
  }
}
```

Esto apunta a un Application Load Balancer con nombre interno “ALB-IEEM-Dev” (según **`elbv2_load_balancers.json`**).

### 2.4 Conclusiones sobre la infraestructura

- **`sqaws.ieem.org.mx`** → **CloudFront** → **`dev-alb.ieem.org.mx`** → **ALB-IEEM-Dev**
- Mientras que la aplicación que responde correctamente en la ruta `/siucs` al usar las IPs `54.226.135.201`/`18.209.62.127` parece **no** formar parte del mismo ALB-IEEM-Dev.

Por eso, cuando uno ingresa a `sqaws.ieem.org.mx/siucs`, CloudFront reenvía la petición a “ALB-IEEM-Dev”, el cual (posiblemente) **no** tiene la aplicación SIUCS desplegada en esa ruta. En cambio, si se ingresa a las IPs directas, uno llega a otro servidor / instancia / ALB donde la aplicación sí está funcionando.

---

## 3. Verificación paso a paso

Para verificar que el ALB-IEEM-Dev efectivamente no tiene `/siucs`, se recomiendan estos comandos de AWS CLI:

1. **Describir los Listeners** de ALB-IEEM-Dev:
    
    ```bash
    aws elbv2 describe-listeners \
        --load-balancer-arn "<ARN de ALB-IEEM-Dev>" \
        --output json
    ```
    
2. **Describir las Reglas** (Rules) de cada Listener:
    
    ```bash
    aws elbv2 describe-rules \
        --listener-arn "<ARN del listener>" \
        --output json
    ```
    
3. **Describir los Target Groups** a los que ese ALB está enviando tráfico:
    
    ```bash
    aws elbv2 describe-target-groups \
        --load-balancer-arn "<ARN de ALB-IEEM-Dev>" \
        --output json
    ```
    
4. **Ver la salud** de las instancias en cada Target Group:
    
    ```bash
    aws elbv2 describe-target-health \
        --target-group-arn "<ARN del target group>" \
        --output json
    ```
    

Si se verifica que las instancias detrás de “ALB-IEEM-Dev” no corresponden a `54.226.135.201` o `18.209.62.127`, queda claro que la aplicación SIUCS **no** está en ese ALB.

---

## 4. Posibles Soluciones

Para que la ruta `sqaws.ieem.org.mx/siucs` funcione igual que acceder por IP, se tienen alternativas:

1. **Configurar el origen de CloudFront hacia el servidor correcto**
    
    - Si las IPs `54.226.135.201` y `18.209.62.127` son parte de otro ALB o una instancia EC2 diferente, debes cambiar en CloudFront el dominio de origen a ese ALB/instancia que contiene SIUCS.
    - O bien, si deseas mantener “ALB-IEEM-Dev”, asegúrate de que la aplicación SIUCS **también** esté desplegada allí.
2. **Eliminar CloudFront y apuntar directamente a un ALB**
    
    - Si no necesitas las funciones de CDN, WAF o caching, podrías editar el registro DNS de “sqaws.ieem.org.mx” en Route53 para que sea un Alias a un ALB distinto (o la IP directamente, si fuera apropiado).
    - De esta forma, `sqaws.ieem.org.mx/siucs` llegaría directo al servidor que ya responde adecuadamente.
3. **Configurar una Regla Path `/siucs` en ALB-IEEM-Dev**
    
    - Verifica si deseas que “ALB-IEEM-Dev” reciba la ruta `/siucs` y la reenvíe a un target group que contenga las instancias correctas para SIUCS. Este enfoque permite que CloudFront → ALB (dev) → Instancias correctas, siempre que la topología se ajuste a la arquitectura deseada.

---

## 5. Resumen

El motivo por el cual no funciona la redirección a `sqaws.ieem.org.mx/siucs` es que dicho dominio pasa por CloudFront y luego al ALB “Dev”, donde la aplicación aparentemente no está configurada. Sin embargo, las IPs directas `54.226.135.201` y `18.209.62.127` apuntan a otro servidor/instancia/ALB que sí sirve la aplicación SIUCS.

**Para resolverlo:**

- Ajustar el **origen de CloudFront** a la instancia/ALB real que contiene “/siucs”.
- O bien **cambiar el registro DNS** para que `sqaws.ieem.org.mx` no vaya a CloudFront, sino al recurso que sí atiende SIUCS.

---

**Fin del Documento**

---

**Instrucciones para generar PDF:**

1. Copia todo este texto en un editor como Word o Google Docs.
2. Ve a la opción “Archivo” → “Guardar como” → “PDF” o “Descargar como PDF”.
3. Listo: tendrás un documento PDF con toda la explicación.