

A continuación, se proporciona una guía rápida que puedes compartir con el cliente para que solucione el problema con Acronis **fuera del alcance del soporte de AWS**, ya que se trata de un tema relacionado directamente con el agente de respaldo de Acronis y su configuración.

---

### **Guía de solución para el error de “Agente sin conexión” en Acronis**

1. **Verificar estado del equipo**
    
    - Asegurarse de que la máquina (física o virtual) donde se ejecuta el agente de Acronis esté encendida, con conexión a la red y acceso a internet.
2. **Revisar servicios de Acronis**
    
    - **Windows**: Abrir “Servicios” (Services.msc) y buscar servicios como “Acronis Managed Machine Service” o similares.
    - Confirmar que estén en estado “En ejecución” (Running).
    - Si el servicio está detenido, iniciarlo.
    - Si no existe, es posible que el agente no esté instalado o se haya dañado.
3. **Comprobar conectividad de red / Firewall**
    
    - Verificar que no existan bloqueos en el firewall local o corporativo que impidan la comunicación del agente con la nube de Acronis.
    - Acronis suele requerir acceso por puerto 443 (HTTPS) a ciertos dominios (por ejemplo, `cloud.acronis.com` u otras URLs específicas según la ubicación de su Data Center).
    - En caso de contar con un proxy, configurar en el agente o en el sistema operativo las credenciales y ajustes adecuados para el acceso a internet.
4. **Verificar credenciales y registro del agente**
    
    - Abrir la consola/portal de Acronis y revisar que el equipo aparezca registrado correctamente.
    - Si el agente fue registrado con credenciales obsoletas, podría requerir un re-registro:
        - Desinstalar el agente (opcional)
        - Volver a instalarlo usando el instalador más reciente provisto por Acronis o tu proveedor de servicio.
        - Durante la instalación, asegurarse de ingresar las credenciales correctas para vincular el agente con el tenant/organización adecuada.
5. **Actualizar a la última versión**
    
    - Revisar si hay una versión más reciente del agente de Acronis disponible.
    - Aplicar actualizaciones tanto al agente como a la consola (si aplicara) para corregir posibles fallos de compatibilidad o de seguridad.
6. **Reiniciar y verificar**
    
    - Tras realizar los ajustes, reiniciar el servicio (o el servidor si fuera necesario) y forzar una sincronización en la consola de Acronis.
    - Validar si la máquina vuelve a aparecer “en línea” y con backups recientes.

---

### **Comentarios sobre la responsabilidad**

- Este problema se relaciona con la configuración, comunicación y registro del **Agente de Acronis**, un software externo a AWS y, por lo tanto, **escapa del marco de responsabilidades de AWS**.
- Para cualquier duda adicional sobre la instalación, configuración o soporte de Acronis, se recomienda contactar al soporte correspondiente de Acronis o de tu proveedor de servicios.

---
