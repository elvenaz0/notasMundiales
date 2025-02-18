

![[Pasted image 20250205161847.png]]

Se actualizo el xrdp a nivel so

sudo zypper up xrdp
Ultr@18*

salida diferente
![[Pasted image 20250205162107.png]]



# **Documento Postmortem y Guía de Solución: Pantalla Negra en XRDP (SUSE Leap 15.4)**

---

## **Resumen del Problema**
Se presentó un problema de **pantalla negra** al intentar conectarse a un servidor SUSE Leap 15.4 mediante **XRDP**. Tras analizar los logs y realizar varias pruebas, se identificaron múltiples causas y se implementaron soluciones para resolver el problema.

---

## **Causas Identificadas**
1. **Certificados SSL faltantes**: XRDP no podía encontrar los archivos de certificados (`cert.pem` y `key.pem`), lo que generaba errores en el log.
2. **Conflictos de sesiones gráficas**: El sistema bloqueaba múltiples sesiones para el mismo usuario debido a políticas de `systemd-logind` y `gdm`.
3. **Entorno gráfico no compatible**: GNOME, el entorno gráfico predeterminado, no es compatible con múltiples sesiones simultáneas.

---

## **Pasos Realizados para la Solución**

### **1. Generación de Certificados SSL**
Se generaron certificados autofirmados para XRDP, ya que los archivos `cert.pem` y `key.pem` no existían.

```bash
sudo openssl req -x509 -newkey rsa:4096 -sha256 -nodes -days 3650 \
  -keyout /etc/xrdp/key.pem \
  -out /etc/xrdp/cert.pem \
  -subj "/CN=$(hostname)"
```

Se ajustaron los permisos de los certificados:
```bash
sudo chmod 600 /etc/xrdp/{cert,key}.pem
sudo chown root:root /etc/xrdp/{cert,key}.pem
```

---

### **2. Configuración de `/etc/xrdp/startwm.sh`**
Se modificó el script de inicio de sesión para forzar el uso de **Xorg** y evitar conflictos con Wayland.

```bash
sudo nano /etc/xrdp/startwm.sh
```

Se añadieron las siguientes líneas al inicio del archivo:
```bash
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
export XDG_SESSION_TYPE=x11
```

---

### **3. Terminación de Sesiones Locales**
Se identificaron y terminaron sesiones locales innecesarias para liberar recursos y evitar conflictos.

```bash
loginctl list-sessions
sudo loginctl terminate-session <ID>
```

---

### **4. Reinicio de Servicios**
Se reinició el servicio XRDP para aplicar los cambios.

```bash
sudo systemctl restart xrdp
```

---

## **Guía de Pasos para Reparar la Pantalla Negra**

### **1. Verificar Certificados SSL**
- Asegúrate de que los archivos `/etc/xrdp/cert.pem` y `/etc/xrdp/key.pem` existan y tengan los permisos correctos.
- Si no existen, genera nuevos certificados:
  ```bash
  sudo openssl req -x509 -newkey rsa:4096 -sha256 -nodes -days 3650 \
    -keyout /etc/xrdp/key.pem \
    -out /etc/xrdp/cert.pem \
    -subj "/CN=$(hostname)"
  sudo chmod 600 /etc/xrdp/{cert,key}.pem
  sudo chown root:root /etc/xrdp/{cert,key}.pem
  ```

---

### **2. Configurar `/etc/xrdp/startwm.sh`**
- Edita el archivo:
  ```bash
  sudo nano /etc/xrdp/startwm.sh
  ```
- Añade estas líneas al inicio:
  ```bash
  unset DBUS_SESSION_BUS_ADDRESS
  unset XDG_RUNTIME_DIR
  export XDG_SESSION_TYPE=x11
  ```

---

### **3. Terminar Sesiones Locales**
- Lista las sesiones activas:
  ```bash
  loginctl list-sessions
  ```
- Termina las sesiones innecesarias:
  ```bash
  sudo loginctl terminate-session <ID>
  ```

---

### **4. Reiniciar XRDP**
- Reinicia el servicio para aplicar los cambios:
  ```bash
  sudo systemctl restart xrdp
  ```

---

## **Conclusión**
El problema de la **pantalla negra en XRDP** se resolvió mediante la generación de certificados SSL, la configuración adecuada del entorno gráfico (GNOME) y la gestión de sesiones locales. Estos pasos garantizan que XRDP funcione correctamente en SUSE Leap 15.4 y permitan conexiones simultáneas.

---

## **Recomendaciones Futuras**
4. **Monitoreo de logs**: Revisar periódicamente `/var/log/xrdp.log` y `/var/log/Xorg.0.log` para detectar errores.
5. **Políticas de sesión**: Configurar `systemd-logind` para permitir múltiples sesiones si es necesario.
6. **Actualizaciones**: Mantener XRDP y los paquetes relacionados actualizados para evitar vulnerabilidades.

---

**Nota**: Si el problema persiste, considera usar **TigerVNC** como alternativa a XRDP. Para más detalles, consulta la [documentación oficial de SUSE](https://www.suse.com/support/kb/doc/?id=000018038).