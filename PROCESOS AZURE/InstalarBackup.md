Para instalar el agente de backup en los clústeres de AKS en Azure y cumplir con los requisitos, sigue estos pasos:

---

### **Pasos detallados:**
1. **Registrar el proveedor de recursos `Microsoft.KubernetesConfiguration`**  
   Ejecuta en Azure CLI:  
   ```bash
   az provider register --namespace Microsoft.KubernetesConfiguration
   ```  
   Verifica el registro:  
   ```bash
   az provider show -n Microsoft.KubernetesConfiguration --query "registrationState"
   ```

2. **Habilitar controladores CSI y snapshots en el clúster**  
   - Si el clúster ya existe, actualiza su configuración con:  
     ```bash
     az aks update -n <nombre-del-clúster> -g <grupo-de-recursos> --enable-csi-driver-snapshot
     ```  
   - Para nuevos clústeres, agrega `--enable-csi-driver-snapshot` al crear el clúster.

3. **Excepción de identidad de pod (si aplica)**  
   Si usas identidades de pod (Pod Identity), crea una excepción para el espacio de nombres `dataprotection-microsoft`:  
   ```bash
   az aks pod-identity exception add --cluster-name <nombre-del-clúster> --resource-group <grupo-de-recursos> --namespace dataprotection-microsoft
   ```

4. **Configurar cuenta de almacenamiento y punto de conexión privado (si el clúster está en una red privada)**  
   - Crea una cuenta de almacenamiento y un contenedor de blobs.  
   - Si el clúster está en una VNet privada, habilita un **Private Endpoint** para la cuenta de almacenamiento siguiendo:  
     [Documentación de Private Endpoint](https://learn.microsoft.com/es-es/azure/storage/common/storage-private-endpoints).

5. **Añadir reglas de firewall/FQDN (si el clúster está en una red restringida)**  
   Permite los siguientes FQDN en el firewall:  
   ```
   *.microsoft.com, *.azure.com, *.core.windows.net, *.azmk8s.io, *.digicert.com, *.digicert.cn, *.geotrust.com, *.msocsp.com
   ```

6. **Verificar región soportada**  
   Consulta la matriz de soporte de Azure Backup para AKS:  
   [Regiones admitidas](https://learn.microsoft.com/es-es/azure/backup/azure-kubernetes-service-cluster-backup-support-matrix).

---

### **Instalación del agente de Backup**  
Una vez cumplidos los requisitos:  
1. Instala la extensión de Azure Backup para AKS desde Azure Portal:  
   - Navega a tu clúster de AKS > **Backup** > **Habilitar Backup**.  
   - Sigue el asistente para vincular la cuenta de almacenamiento y configurar políticas.  

2. **O mediante Azure CLI**:  
   ```bash
   az k8s-extension create --name azure-aks-backup \
     --cluster-name <nombre-del-clúster> \
     --resource-group <grupo-de-recursos> \
     --cluster-type managedClusters \
     --extension-type Microsoft.DataProtection.Kubernetes
   ```

---

### **Validación**  
- Verifica que la extensión esté en estado **Instalado** en el portal.  
- Ejecuta una copia de seguridad de prueba para confirmar que funciona correctamente.  

Si encuentras errores, revisa los requisitos o consulta los registros de implementación en el clúster.