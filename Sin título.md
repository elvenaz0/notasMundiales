

Con base en los archivos JSON que has proporcionado (Route53, ALBs y CloudFront), esto es lo que se observa y cómo verificar el requerimiento de “sqaws.ieem.org.mx/siucs”:

---

## 1) **`sqaws.ieem.org.mx` apunta a CloudFront**

En `route53_records.json` se ve que el registro para `sqaws.ieem.org.mx` **no** apunta a un ALB directamente, sino a una distribución de CloudFront:

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

Lo anterior significa que cualquier tráfico hacia `https://sqaws.ieem.org.mx/` llega primero a CloudFront en lugar de llegar de forma directa a un Application Load Balancer.

---

## 2) **Distribución de CloudFront asociada**

En `cloudfront_list.json` aparece la distribución con dominio `d3qaxn8vc1rt6w.cloudfront.net`:

```json
{
  "Id": "E3BTFAN3RDII2S",
  "DomainName": "d3qaxn8vc1rt6w.cloudfront.net",
  "Aliases": {
    "Items": [
      "sqaws.ieem.org.mx"
    ]
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

Esto confirma que la distribución de CloudFront con ID `E3BTFAN3RDII2S` es la que atiende las solicitudes a `sqaws.ieem.org.mx`.

Observa que su **Origin** apunta a:

```
"DomainName": "dev-alb.ieem.org.mx"
```

y no directamente a un ALB tipo `ALB-IEEM-Prep-Pro...`.

---

## 3) **¿A qué ALB corresponde `dev-alb.ieem.org.mx`?**

En `route53_records.json`, busca el registro `dev-alb.ieem.org.mx`:

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

Es un alias a:

```
dualstack.alb-ieem-dev-405231709.us-east-1.elb.amazonaws.com
```

que corresponde en tus ALBs a:

```
ALB-IEEM-Dev
(DNSName: ALB-IEEM-Dev-405231709.us-east-1.elb.amazonaws.com)
```

Por lo tanto, CloudFront está enviando el tráfico a **`ALB-IEEM-Dev`**.

---

## 4) **Revisar por qué /siucs funciona con la IP pero no con el dominio**

### a) IPs mencionadas

Tú comentas que entrando a:

- `http://54.226.135.201/siucs`
- `http://18.209.62.127/siucs`

la aplicación **sí** responde correctamente, mientras que con `sqaws.ieem.org.mx/siucs` no sucede la redirección o acceso correcto. Eso sugiere que esas IPs quizá pertenecen a otra instancia (o a otro ALB/instancia) diferente de la que está detrás de `ALB-IEEM-Dev`.

### b) CloudFront y `ALB-IEEM-Dev`

Por la configuración actual, el tráfico `sqaws.ieem.org.mx/siucs` llega a CloudFront y de ahí va al ALB “Dev”. Es probable que:

- La aplicación de `siucs` no esté desplegada en ese ALB/instancia.
- O falte la configuración de la ruta `/siucs` en tu ALB “Dev” (reglas del listener) o en el servidor que atiende esa ruta.
- O la instancia que atiende “Dev” es distinta a la que corresponde a las IPs `54.226.135.201`/`18.209.62.127`.

En otras palabras, CloudFront → ALB-IEEM-Dev → (alguna instancia) no está respondiendo a la ruta `/siucs`, mientras que accediendo directamente a otras IPs **sí** llega al servidor correcto.

---

## 5) **¿Cómo verificarlo a detalle?**

Para confirmar:

1. **Describe** la distribución de CloudFront `E3BTFAN3RDII2S` (si no lo has hecho ya) para ver si hay comportamientos (CacheBehaviors) específicos para `/siucs`. Pero según el JSON, **no** hay `CacheBehaviors` adicionales (solo el `DefaultCacheBehavior`). Por tanto, cualquier ruta `/` o `/siucs` se reenvía igual al mismo origen.
    
2. **Revisa** la configuración del **ALB-IEEM-Dev** (listeners y reglas) con:
    
    ```
    aws elbv2 describe-listeners \
        --load-balancer-arn <ARN_DE_ALB-IEEM-Dev>
        --output json
    aws elbv2 describe-rules \
        --listener-arn <ARN_DEL_LISTENER> \
        --output json
    ```
    
    Verifica si hay alguna regla para `/siucs`. Si no la hay, por defecto se reenvía al target group principal y depende de la configuración del servidor web.
    
3. **Comprueba** que el **servidor** (EC2) detrás de “ALB-IEEM-Dev” (o contenedor, etc.) **tenga** la aplicación `siucs` disponible en la ruta `/siucs`. Si no existe, va a fallar.
    
4. **Compara** las IPs `54.226.135.201` y `18.209.62.127` con las instancias o tareas que están detrás del ALB-IEEM-Dev. Usa:
    
    ```
    aws elbv2 describe-target-groups \
        --load-balancer-arn <ARN_DE_ALB-IEEM-Dev> \
        --output json
    aws elbv2 describe-target-health \
        --target-group-arn <ARN_DEL_TARGET_GROUP> \
        --output json
    ```
    
    Mira cuáles instancias están en `healthy` y qué IP tienen. Así verás si esas IPs coinciden o no.
    

---

## 6) **Cómo atender el requerimiento**

El solicitante quiere que, **cuando entren a** `sqaws.ieem.org.mx/siucs`, **funcione igual que** `http://54.226.135.201/siucs` y `http://18.209.62.127/siucs`. Para lograrlo:

1. **Opción A: Configurar correctamente CloudFront + ALB**
    
    - En el ALB y el backend, asegurarte de que `/siucs` esté desplegado y en **el mismo servidor** que maneja las IPs 54.226.x.x y 18.209.x.x.
    - Si esas IPs pertenecen a otra instancia que no está detrás de ALB-IEEM-Dev, podrías cambiar la **Origin** de CloudFront para que en vez de apuntar a `dev-alb.ieem.org.mx` apunte al ALB/instancia correctos (los que sirven SIUCS).
    - También verifica que uses `Origin Protocol Policy = HTTPS-Only` si tu ALB tiene HTTPS disponible.
2. **Opción B: Apuntar directamente a un ALB en Route53**
    
    - Si no necesitas CloudFront, podrías editar el registro de `sqaws.ieem.org.mx` y hacerlo un Alias a uno de los ALBs (por ejemplo, “ALB-IEEM-Prep-Pro” o el que contenga la app SIUCS).
    - Perderías las funciones de CDN/WAF de CloudFront (a menos que se configure en el ALB o en AWS WAF), pero te aseguras de que `sqaws.ieem.org.mx` vaya directo al ALB que ya funciona con SIUCS.
3. **Opción C: Mantener CloudFront, pero cambiar la originPath**
    
    - Podrías establecer en la configuración de CloudFront `OriginPath = /siucs` y luego la aplicación se serviría en la raíz. Pero esto solo aplica si la app está en la raíz del ALB.
    - Requeriría ajustes en la configuración y testing.

En la práctica, la **solución más sencilla** suele ser:

1. Identificar en cuál ALB (o instancias) está corriendo la app SIUCS que responde en `54.226.135.201/siucs` y `18.209.62.127/siucs`.
2. Cambiar la distribución de CloudFront a **ese** origen, o eliminar CloudFront si no se requiere.

---

### Resumen final

- `sqaws.ieem.org.mx` hoy **va a CloudFront** (distribución `E3BTFAN3RDII2S`), que a su vez **reenvía** a `dev-alb.ieem.org.mx` (ALB-IEEM-Dev).
- Los IPs mencionados (54.226.x.x / 18.209.x.x) aparentemente **no** son parte del ALB-IEEM-Dev, así que esa ruta funciona directo, pero no a través de CloudFront/ALB.
- Para que “sqaws.ieem.org.mx/siucs” responda igual que las IPs, necesitas **unificar** la configuración: o mover la app SIUCS al mismo origen que CloudFront está usando, o apuntar CloudFront (o el DNS) hacia el ALB/instancia correctos que realmente sirven SIUCS.

Con eso verificas el requerimiento y explicas por qué la redirección falla a través del dominio pero sí responde por IP.