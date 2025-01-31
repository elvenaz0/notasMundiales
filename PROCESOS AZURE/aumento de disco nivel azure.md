# Guía para Aumentar el Tamaño de Disco de una VM en Azure

Esta guía describe los pasos para aumentar el tamaño del disco de una máquina virtual (VM) en Azure. Este proceso incluye expandir el disco a nivel de Azure y luego ajustar la partición dentro del sistema operativo de la VM.

---

## **1. Expandir el Disco desde el Portal de Azure**

1. **Accede al Portal de Azure:**
   - Ve a [portal.azure.com](https://portal.azure.com).

2. **Selecciona la Máquina Virtual:**
   - En el menú lateral, selecciona **Virtual Machines**.
   - Elige la VM que deseas modificar.

3. **Detén la VM (opcional, pero recomendado):**
   - Haz clic en **Stop** para detener la VM de forma segura.

4. **Accede a los Discos:**
   - En el menú lateral de la VM, selecciona **Disks**.
   - Haz clic en el disco que deseas expandir (por ejemplo, `OS Disk`).

5. **Editar el Tamaño del Disco:**
   - Haz clic en **Configuration** o **Size + performance**.
   - Cambia el tamaño del disco en el campo **Size (GB)** (por ejemplo, aumenta de 128 GB a 256 GB).
   - Haz clic en **Save** para guardar los cambios.

6. **Inicia la VM (si fue detenida):**
   - Regresa a la página principal de la VM y haz clic en **Start** para encenderla.

---

## **2. Expandir la Partición dentro del Sistema Operativo**

### **En Windows:**
1. **Accede a la VM usando RDP:**
   - Conéctate a la VM usando Remote Desktop Protocol (RDP).

2. **Abrir el Administrador de Discos:**
   - Presiona **Win + R**, escribe `diskmgmt.msc` y presiona **Enter**.

3. **Extender la Partición:**
   - Haz clic derecho en la partición principal (`C:`).
   - Selecciona **Extender volumen...**.
   - Sigue las instrucciones del asistente para usar el espacio no asignado.

4. **Verifica el Resultado:**
   - Abre el Explorador de Archivos y confirma que la partición tiene el nuevo tamaño.

### **En Linux:**
1. **Accede a la VM usando SSH:**
   - Conéctate a la VM mediante SSH desde la terminal o Azure Cloud Shell.

2. **Verifica el Disco Actual:**
   ```bash
   lsblk
   ```
   Esto muestra las particiones y el espacio disponible.

3. **Expandir la Partición:**
   - Si utilizas `growpart`:
     ```bash
     sudo growpart /dev/sda 1
     ```
     (Reemplaza `/dev/sda` con el disco correspondiente y `1` con la partición).

4. **Redimensionar el Sistema de Archivos:**
   - Si el sistema de archivos es `ext4`:
     ```bash
     sudo resize2fs /dev/sda1
     ```
     (Ajusta el nombre de la partición según corresponda).

5. **Verifica el Nuevo Tamaño:**
   ```bash
   df -h
   ```

---

## **3. Validar los Cambios**

1. **Confirma en el Portal de Azure:**
   - Revisa que el tamaño del disco refleje el valor actualizado.

2. **Verifica en el Sistema Operativo:**
   - Asegúrate de que la partición se haya expandido correctamente y el espacio adicional esté disponible.

---

## **4. Consideraciones Finales**

- **Respaldo:** Siempre realiza un respaldo del disco antes de modificarlo, en caso de que algo salga mal.
- **Compatibilidad:** Asegúrate de que el tamaño del disco solicitado sea compatible con el tipo de disco y la región de tu suscripción.
- **Reinicios:** Aunque Azure permite expandir discos en caliente, algunos sistemas operativos pueden requerir un reinicio para reconocer el nuevo tamaño del disco.

---

Con estos pasos, podrás aumentar el tamaño del disco de tu máquina virtual en Azure y usar el espacio adicional en el sistema operativo. Si tienes problemas adicionales, revisa la configuración del disco y la conexión de red. 🚀