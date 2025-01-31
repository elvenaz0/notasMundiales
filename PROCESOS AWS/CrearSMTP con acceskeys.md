(Due to technical issues, the search service is temporarily unavailable.)

Aquí tienes el documento en Markdown con los pasos detallados y explicaciones:

```markdown
# Obtención de Credenciales SMTP para Usuarios IAM en AWS

Este documento explica cómo generar credenciales SMTP para usuarios de IAM en AWS, necesarias para enviar correos mediante Amazon SES (Simple Email Service).

---

## 📋 Requisitos Previos
- **Cuenta de AWS** con acceso a IAM y SES.
- **Usuario IAM** con permisos para SES (o crear uno nuevo).
- **PowerShell** (Windows) o terminal con **OpenSSL** (Linux/macOS).

---

## 🛠️ Pasos para Configurar las Credenciales

### 1. **Crear un Usuario IAM**
   - **Propósito**: Definir una identidad con permisos para enviar correos.
   - **Pasos**:
     1. Ve a la consola de **IAM** > **Usuarios** > **Crear usuario**.
     2. Asigna un nombre (ej. `smtp-user`) y haz clic en **Siguiente**.
     3. En **Permisos**, adjunta la política `AmazonSESFullAccess` o una política personalizada que incluya `ses:SendRawEmail`.
     ```json
     // Ejemplo de política personalizada
     {
       "Version": "2012-10-17",
       "Statement": [{
         "Effect": "Allow",
         "Action": "ses:SendRawEmail",
         "Resource": "*"
       }]
     }
     ```
     4. Crea el usuario.

### 2. **Generar Claves de Acceso (Access Keys)**
   - **Propósito**: Obtener las credenciales de IAM para autenticación.
   - **Pasos**:
     1. En la página del usuario IAM, ve a la pestaña **Claves de seguridad**.
     2. Haz clic en **Crear clave de acceso**.
     3. Elige el tipo **Aplicación externa** y confirma.
     4. **Guarda** el `Access Key ID` y `Secret Access Key` (solo se muestran una vez).

### 3. **Generar la Contraseña SMTP**
   - **Propósito**: Convertir el `Secret Access Key` en una contraseña compatible con SMTP.
   - **Método 1: Usando PowerShell** (Windows):
     ```powershell
     # Variables
     $secretKey = "TU_SECRET_ACCESS_KEY"
     $message = "SendRawEmail"

     # Generar HMAC-SHA256
     $hmac = New-Object System.Security.Cryptography.HMACSHA256
     $hmac.Key = [Text.Encoding]::UTF8.GetBytes($secretKey)
     $hash = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($message))

     # Convertir a Base64
     $smtpPassword = [Convert]::ToBase64String($hash)
     Write-Output "Contraseña SMTP: $smtpPassword"
     ```

   - **Método 2: Usando OpenSSL** (Linux/macOS/Windows con OpenSSL):
     ```bash
     echo -n "SendRawEmail" | openssl dgst -sha256 -hmac TU_SECRET_ACCESS_KEY -binary | base64
     ```

### 4. **Configurar el Cliente SMTP**
   - **Parámetros**:
     - **Servidor SMTP**: `email-smtp.<REGION>.amazonaws.com` (ej. `email-smtp.us-east-1.amazonaws.com`).
     - **Puerto**: `587` (TLS) o `465` (SSL).
     - **Usuario**: Tu `Access Key ID` de IAM.
     - **Contraseña**: El resultado del paso 3.

---

## ⚠️ Notas Importantes
- **Región**: Usa la misma región donde está configurado SES.
- **Modo Sandbox**: Si tu cuenta está en modo sandbox, solo podrás enviar correos a direcciones verificadas.
- **Seguridad**:
  - Nunca expongas el `Secret Access Key`.
  - Usa AWS Secrets Manager para almacenar credenciales en aplicaciones productivas.

---

## 🔍 Validación de Credenciales
Prueba las credenciales con un cliente SMTP como **Thunderbird** o usando `openssl`:
```bash
openssl s_client -crlf -starttls smtp -connect email-smtp.us-east-1.amazonaws.com:587
```
- Autentícate con tu `Access Key ID` y la contraseña generada.

---

## ❓ Preguntas Frecuentes
- **¿Por qué no veo la opción SMTP en IAM?**  
  AWS no genera credenciales SMTP directamente. Se requiere convertir manualmente las claves de IAM.

- **Error `454 4.7.0 Too many login attempts`**  
  Verifica que la contraseña SMTP se generó correctamente y que el usuario tiene permisos para `ses:SendRawEmail`.

- **¿Cómo salir del modo sandbox de SES?**  
  Solicita el aumento de límites en la consola de SES.

---

## 📌 Conclusión
Las credenciales SMTP permiten integrar aplicaciones con Amazon SES usando protocolo SMTP estándar. Asegúrate de:
1. Restringir permisos al mínimo necesario (principio de menor privilegio).
2. Rotar las claves de acceso periódicamente.
3. Verificar dominios o direcciones de correo en SES.

```

---

### 📥 Cómo Usar Este Documento
4. Copia el contenido en un archivo `.md`.
5. Reemplaza `TU_SECRET_ACCESS_KEY` y `<REGION>` con tus valores reales.
6. Ejecuta los comandos según tu sistema operativo.