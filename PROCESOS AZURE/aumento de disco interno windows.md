# Guía para Aumentar el Tamaño de Disco en Windows

Esta guía explica cómo aumentar el tamaño de un disco en una máquina virtual de Windows. Incluye los pasos necesarios para realizar esta operación desde el sistema operativo, teniendo en cuenta posibles escenarios como la presencia de particiones de recuperación.

---

## **1. Verificar el Espacio Adicional en el Disco**

Antes de extender una partición, verifica si el espacio adicional está disponible:

1. **Abrir el Administrador de Discos:**
   - Presiona **Win + R**, escribe `diskmgmt.msc` y presiona **Enter**.

2. Busca el disco que deseas extender (por ejemplo, `C:`) y verifica si hay **espacio no asignado** contiguo a la partición.

   - Si no hay espacio adicional disponible, primero debes expandir el disco desde el portal de Azure o Azure CLI.

---

## **2. Extender la Partición (Sin Partición Intermedia)**

Si el espacio no asignado es contiguo a la partición que deseas extender:

1. Haz clic derecho sobre la partición que deseas extender (por ejemplo, `C:`).
2. Selecciona **Extender volumen...**.
3. Sigue el asistente para usar el espacio no asignado.

---

## **3. Solución para Particiones Intermedias (Partición de Recuperación)**

Si hay una partición de recuperación (o cualquier otra partición) entre la partición principal y el espacio no asignado, tienes dos opciones:

### **Opción 1: Eliminar la Partición de Recuperación**

**Nota:** Esto elimina la capacidad de restaurar Windows desde esta partición, pero no afecta el funcionamiento normal del sistema operativo.

1. Abre el **Administrador de Discos**.
2. Haz clic derecho sobre la **partición de recuperación**.
3. Selecciona **Eliminar volumen**.
4. Confirma la operación.
5. Ahora, el espacio no asignado será contiguo a la partición principal (`C:`).
6. Haz clic derecho sobre la partición `C:` y selecciona **Extender volumen...**.

### **Opción 2: Mover la Partición de Recuperación** (Usando Herramientas de Terceros)

Si no quieres eliminar la partición de recuperación, utiliza herramientas como **MiniTool Partition Wizard**:

1. Descarga e instala [MiniTool Partition Wizard](https://www.partitionwizard.com/).
2. Selecciona la partición de recuperación.
3. Usa la opción **Mover** para colocarla al final del disco.
4. Aplica los cambios.
5. Extiende la partición `C:` utilizando el espacio contiguo.

---

## **4. Usar PowerShell para Extender el Disco**

Si prefieres usar comandos:

1. **Abrir PowerShell como Administrador:**
   - Haz clic derecho en el menú de inicio y selecciona **Windows PowerShell (Administrador)**.

2. **Verificar particiones disponibles:**
   ```powershell
   Get-Partition
   ```

3. **Verificar el tamaño máximo soportado para la partición:**
   ```powershell
   Get-PartitionSupportedSize -DriveLetter C
   ```

4. **Extender la partición al tamaño máximo:**
   ```powershell
   Resize-Partition -DriveLetter C -Size (Get-PartitionSupportedSize -DriveLetter C).SizeMax
   ```

5. **Verificar que el tamaño se haya actualizado:**
   ```powershell
   Get-Partition
   ```

---

## **5. Verificar el Resultado**

1. Abre el **Explorador de Archivos**.
2. Haz clic derecho sobre la unidad extendida (por ejemplo, `C:`) y selecciona **Propiedades**.
3. Verifica el nuevo tamaño del disco.

---

## **6. Consideraciones Finales**

- **Crear un respaldo:** Antes de realizar cambios en las particiones, es recomendable realizar un respaldo completo de los datos importantes.
- **Partición de recuperación:** Si eliminas la partición de recuperación, asegúrate de contar con un medio de recuperación externo, como un USB de instalación de Windows.
- **Uso de herramientas de terceros:** Herramientas como **MiniTool Partition Wizard** o **EaseUS Partition Master** son muy útiles para mover particiones sin perder datos.

---
