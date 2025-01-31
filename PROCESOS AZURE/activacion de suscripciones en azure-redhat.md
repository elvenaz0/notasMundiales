**Explicación del error y solución:**

El mensaje `Overall Status: Disabled` en `subscription-manager status` indica que las máquinas virtuales **no están correctamente asociadas a una suscripción activa de Red Hat** o que el registro en Red Hat Subscription Manager (RHSM) está incompleto. Aunque el modo "Simple Content Access" permite acceder a contenido sin una suscripción válida, es necesario resolver el estado de la suscripción para cumplir con los requisitos del cliente y garantizar soporte oficial.

---

### **Pasos para corregir el error y activar las máquinas:**

1. **Verificar el registro en Red Hat Subscription Manager:**
   - Ejecute en cada máquina:
     ```bash
     sudo subscription-manager identity
     ```
   - Si no hay salida (o muestra `This system is not yet registered`), la máquina no está registrada.

2. **Registrar las máquinas en RHSM:**
   - Use las credenciales de Red Hat del cliente:
     ```bash
     sudo subscription-manager register --username=<usuario_redhat> --password=<contraseña_redhat>
     ```
   - Si el entorno requiere un servidor proxy, agregue `--proxy=<proxy_url> --proxyuser=<proxy_user>`.

3. **Adjuntar una suscripción válida:**
   - Después del registro, asigne una suscripción automáticamente:
     ```bash
     sudo subscription-manager attach --auto
     ```
   - Si hay múltiples suscripciones, especifique el *pool ID*:
     ```bash
     sudo subscription-manager attach --pool=<pool_id>
     ```

4. **Configurar System Purpose (opcional pero recomendado):**
   - Establezca el propósito del sistema para alinearse con la suscripción:
     ```bash
     sudo subscription-manager syspurpose --set-role=<rol> --set-usage=<uso> --set-service-level=<SLA>
     ```
     Ejemplo:
     ```bash
     sudo subscription-manager syspurpose --set-role="Red Hat Enterprise Linux Server" --set-usage="Production" --set-service-level="Premium"
     ```

5. **Verificar el estado final:**
   - Ejecute nuevamente:
     ```bash
     sudo subscription-manager status
     ```
   - El resultado debería mostrar:
     ```
     Overall Status: Current
     System Purpose Status: Matched
     ```

---

### **Notas adicionales:**
- **Azure y Red Hat:** Asegúrese de que las suscripciones de Red Hat estén vinculadas a la cuenta de Azure del cliente (si usan "Red Hat Gold Images" o "Azure Marketplace"). Esto simplifica la gestión de licencias.
- **Errores comunes:**
  - **Credenciales incorrectas:** Verifique que el usuario/contraseña de Red Hat sean válidos.
  - **Problemas de conectividad:** Confirme que las máquinas tengan acceso a `subscription.rhsm.redhat.com` (puerto 443).
  - **Suscripciones agotadas:** Revise el portal de Red Hat para confirmar que hay disponibilidad en el *pool* asignado.

Si el problema persiste, proporcione la salida de `sudo subscription-manager list --available` y `sudo subscription-manager facts` para un diagnóstico más detallado.