
1. **Verificar conectividad de red desde el Gateway**
    
    - Asegúrate de que el servidor donde está instalado el On-Premises Data Gateway (o el gateway de Fabric) _sí_ pueda resolver el DNS y llegar a la URL `scu.frontend.clouddatahub.net`.
    - Haz un _ping_ o un _tracert_ (traceroute) a `scu.frontend.clouddatahub.net` para confirmar que la resolución de nombres y la ruta de red funcionan correctamente.
    - Confirma que el firewall o proxy de tu organización no bloquee el tráfico saliente hacia ese dominio.
2. **Puertos y reglas de firewall**
    
    - Microsoft Fabric y los servicios de Power BI típicamente necesitan conectividad saliente por HTTPS (puerto 443) a varios endpoints de Microsoft.
    - Verifica que tu firewall o proxy permita las solicitudes salientes hacia `scu.frontend.clouddatahub.net` (puerto 443).
    - Revisa también si se requiere alguna configuración de proxy o credenciales para que el Gateway se conecte a internet (por ejemplo, en entornos corporativos con proxies restringidos).
3. **Reiniciar el servicio del Gateway**
    
    - A veces, tras restablecer la conectividad o corregir alguna regla de firewall, es necesario reiniciar el servicio del On-Premises Data Gateway (o Fabric Gateway) para que se reflejen los cambios.
    - Si no sabes en qué servidor está corriendo, localiza el servidor donde esté instalado el Gateway e inicia sesión con una cuenta que tenga privilegios de administrador para poder reiniciarlo.
4. **Validar la cadena de conexión a SAP HANA**
    
    - Confirma que la IP y el puerto (por ejemplo, `11.0.6.216:30015`) todavía sean correctos y sigan abiertos.
    - Si SAP HANA se cambió de servidor, de IP o de puerto recientemente, asegúrate de actualizar la configuración en Microsoft Fabric.
    - Revisa igualmente credenciales o certificados que pudieran haber expirado (si usas SSL/TLS en la conexión).
5. **Actualización del Gateway**
    
    - Asegúrate de tener el On-Premises Data Gateway actualizado a la versión más reciente, ya que a veces pueden surgir incompatibilidades entre versiones antiguas y servicios más nuevos.
6. **Logs de diagnóstico**
    
    - Si después de todo lo anterior todavía hay problemas, revisa los _logs_ del Gateway (normalmente en la carpeta de instalación del Gateway) para ver detalles de por qué no se conecta.
    - Allí se suelen registrar errores más específicos que te ayuden a identificar si es un problema de DNS, de autenticación, de SSL, etc.
