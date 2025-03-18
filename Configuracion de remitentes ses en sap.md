
### **Causa del problema**

Al migrar de **Microsoft SMTP a AWS SES**, el nombre del remitente ("Notificaciones de Farmacia San Pablo") no se conserva porque:

1. **AWS SES no infiere el nombre del remitente** desde las credenciales SMTP, sino que lo toma directamente del campo `From` configurado en los encabezados del correo.
    

2. **Microsoft SMTP** podría estar usando un método alternativo (ej: configuración global en el servidor) para asignar el nombre, lo que no aplica para AWS SES.
    

---

### **Solución: Ajustar la configuración en SAP**

Para garantizar que los correos lleguen con el nombre correcto, es necesario configurar explícitamente el **"From Name"** en SAP siguiendo estos pasos:

1. **Formato del campo "Remitente" en SAP**
    

Asegúrense de que el campo **`From` (Remitente)** en SAP incluya tanto el **nombre deseado** como la **dirección de correo**, usando este formato:

```plaintext

"Notificaciones de Farmacia San Pablo" <[notificaciones@fsanpablo.com](mailto:notificaciones@fsanpablo.com)>

```

*Nota:* Las comillas (`"`) alrededor del nombre son críticas para que AWS SES reconozca el texto como el nombre del remitente.

1. **Ejemplo de configuración válida**
    

| Parámetro | Valor |

| **Servidor SMTP** | `email-smtp.us-east-1.amazonaws.com:587` |

| **From (Remitente)** | `"Notificaciones de Farmacia San Pablo" <[notificaciones@fsanpablo.com](mailto:notificaciones@fsanpablo.com)>` |

1. **Verificación en SAP**
    

- Revisen la transacción **SCOT** (Configuración de comunicación de SAP).
    

- En la sección de **"Default Domain"**, asegúrense de que el campo `From` siga el formato mencionado.