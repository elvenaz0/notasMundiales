Para solucionar este problema en los Storage Accounts donde no aparece la opción para habilitar los backups, sigue estos pasos:

### Verificar la configuración del tipo de cuenta de almacenamiento

1. **Tipo de cuenta**: Asegúrate de que el tipo de cuenta de almacenamiento sea **General Purpose v2 (GPv2)**. Algunas características, como la configuración de backups, no están disponibles en cuentas de almacenamiento más antiguas (por ejemplo, BlobStorage o General Purpose v1).
    
    - Esto se puede verificar en el panel "Overview" del Storage Account. Según tu imagen, el tipo de cuenta ya es **StorageV2 (general purpose v2)**, lo cual es compatible.
2. **Redundancia**: Confirma que el tipo de redundancia sea compatible. **GRS (Geo-Redundant Storage)** y **LRS (Locally-Redundant Storage)** generalmente soportan configuraciones de backup.
    

---

### Revisar si la región es compatible

Algunas características avanzadas pueden no estar disponibles en todas las regiones de Azure. Verifica que la región donde está configurado el Storage Account soporte los backups. En tu imagen, la región es **East US**, lo cual suele ser compatible.

---

### Comprobar permisos y acceso

1. **Permisos del usuario**: Asegúrate de que el usuario que intenta configurar los backups tenga permisos de **Contributor** o superiores en el recurso.
    
    - Ve a **Access Control (IAM)** y revisa las asignaciones de roles.
2. **Políticas de la suscripción**: Verifica que no haya políticas de gobernanza o restricciones en la suscripción que limiten la habilitación de esta funcionalidad.
    

---

### Habilitar configuraciones de recuperación

Por lo que se observa en las imágenes:

- Tienes habilitada la **Soft Delete para blobs y contenedores**. Esto protege contra eliminaciones accidentales, pero no es un backup completo.
- Para habilitar configuraciones de backup más avanzadas, podrías estar buscando **Azure Backup** para Storage Accounts.

### Pasos para habilitar backups avanzados:

1. Ve al recurso de **Azure Backup** en el portal.
2. Selecciona la opción de **+ Backup**.
3. Elige como **Workload type**: **Azure Files (Azure Storage)**.
4. Configura una nueva "Backup Policy" para el recurso.

---

### Validar que la funcionalidad de backup esté activada

En caso de que aún no veas la opción:

1. Asegúrate de que la suscripción incluya la funcionalidad requerida. Podrías necesitar registrar manualmente el proveedor de recursos:
    - Abre **Azure CLI** o PowerShell y ejecuta:
        
        ```bash
        az provider register --namespace Microsoft.DataProtection
        az provider register --namespace Microsoft.RecoveryServices
        ```
        
2. Luego, vuelve a intentar configurar el backup.

---

Si después de estos pasos aún no logras habilitarlo, es posible que necesites abrir un ticket de soporte en Azure para confirmar si hay limitaciones específicas para tu cuenta o región.