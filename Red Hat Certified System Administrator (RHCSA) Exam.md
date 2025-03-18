
**Temario detallado para el Red Hat Certified System Administrator (RHCSA) con teoría y ejemplos prácticos**  
*(Basado en RHEL 8/9)*  

---

### **1. Gestión de Archivos y Sistemas de Archivos**  
**Teoría:**  
- Jerarquía estándar de directorios (FHS: Filesystem Hierarchy Standard).  
- Comandos básicos: `ls`, `cp`, `mv`, `rm`, `find`, `grep`.  
- Permisos y ownership: `chmod`, `chown`, `chgrp`.  

**Ejemplo práctico:**  
```bash
# Buscar archivos modificados en los últimos 7 días en /var/log:
find /var/log -type f -mtime -7

# Cambiar permisos de un script para que sea ejecutable por el grupo:
chmod g+x /ruta/al/script.sh
```

---

### **2. Administración de Usuarios y Grupos**  
**Teoría:**  
- Archivos clave: `/etc/passwd`, `/etc/shadow`, `/etc/group`.  
- Comandos: `useradd`, `usermod`, `userdel`, `groupadd`, `passwd`.  

**Ejemplo práctico:**  
```bash
# Crear un usuario "juan" con UID 1500 y grupo principal "developers":
sudo useradd -u 1500 -g developers juan

# Establecer contraseña:
echo "password123" | sudo passwd --stdin juan
```

---

### **3. Gestión de Almacenamiento con LVM**  
**Teoría:**  
- Componentes de LVM: **PV** (Physical Volume), **VG** (Volume Group), **LV** (Logical Volume).  
- Comandos: `pvcreate`, `vgcreate`, `lvcreate`, `lvextend`, `resize2fs`/`xfs_growfs`.  

**Ejemplo práctico:**  
```bash
# Crear un LV de 5GB en el VG "vg_data":
sudo lvcreate -n lv_app -L 5G vg_data

# Formatear como XFS:
sudo mkfs.xfs /dev/vg_data/lv_app

# Extender un LV a 10GB y redimensionar el filesystem:
sudo lvextend -L +5G /dev/vg_data/lv_app
sudo xfs_growfs /ruta/de/montaje
```

---

### **4. Administración de Paquetes con DNF/YUM**  
**Teoría:**  
- Instalación, actualización y eliminación de paquetes.  
- Repositorios: Habilitar/deshabilitar con `dnf config-manager`.  

**Ejemplo práctico:**  
```bash
# Instalar Apache y habilitarlo:
sudo dnf install httpd -y
sudo systemctl enable --now httpd

# Buscar paquetes relacionados con "python3":
sudo dnf search python3
```

---

### **5. Gestión de Servicios con Systemd**  
**Teoría:**  
- Comandos: `systemctl start|stop|restart|enable|status [servicio]`.  
- Archivos de unidad: `.service`, `.target`.  

**Ejemplo práctico:**  
```bash
# Verificar el estado de firewalld:
sudo systemctl status firewalld

# Habilitar un servicio para que inicie al arranque:
sudo systemctl enable nfs-server
```

---

### **6. Configuración de Redes**  
**Teoría:**  
- Herramientas: `nmcli`, `nmtui`, archivos en `/etc/sysconfig/network-scripts/`.  
- Configuración IP estática/dinámica.  

**Ejemplo práctico:**  
```bash
# Configurar IP estática en la interfaz enp0s3:
sudo nmcli con mod enp0s3 ipv4.addresses 192.168.1.100/24
sudo nmcli con mod enp0s3 ipv4.gateway 192.168.1.1
sudo nmcli con up enp0s3
```

---

### **7. Firewall con Firewalld**  
**Teoría:**  
- Zonas, servicios y puertos.  
- Comandos: `firewall-cmd`.  

**Ejemplo práctico:**  
```bash
# Permitir HTTP/HTTPS en la zona pública:
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
```

---

### **8. Administración de SELinux**  
**Teoría:**  
- Modos: Enforcing, Permissive, Disabled.  
- Comandos: `getenforce`, `setenforce`, `chcon`, `restorecon`, `semanage`.  

**Ejemplo práctico:**  
```bash
# Cambiar el contexto de un archivo para servicio web:
sudo chcon -t httpd_sys_content_t /var/www/html/index.html

# Verificar contextos:
ls -Z /var/www/html/index.html
```

---

### **9. Gestión de Tareas Programadas (Cron)**  
**Teoría:**  
- Archivos: `/etc/crontab`, `/var/spool/cron/`.  
- Comando: `crontab -e`.  

**Ejemplo práctico:**  
```bash
# Programar backup diario a las 2 AM:
echo "0 2 * * * /usr/local/bin/backup.sh" | sudo crontab -u root -
```

---

### **10. Montaje Automático de Filesystems (/etc/fstab)**  
**Teoría:**  
- Campos: Dispositivo, punto de montaje, tipo, opciones, dump, pass.  
- Comando: `mount -a`.  

**Ejemplo práctico:**  
```bash
# Añadir entrada en /etc/fstab para montar un LV al arranque:
/dev/vg_data/lv_app /data xfs defaults 0 0

# Probar la configuración:
sudo mount -a
```

---

### **11. Gestión de Logs (journald y rsyslog)**  
**Teoría:**  
- Comandos: `journalctl`, configuración de `/etc/rsyslog.conf`.  

**Ejemplo práctico:**  
```bash
# Ver logs del servicio httpd:
journalctl -u httpd --since "2023-10-01"

# Buscar errores en los últimos 30 minutos:
journalctl --since "30 minutes ago" -p err
```

---

### **12. Resolución de Problemas Básicos**  
**Teoría:**  
- Recuperación de root password.  
- Modo de rescate y emergencia.  

**Ejemplo práctico:**  
1. Reiniciar y editar la línea de kernel en GRUB añadiendo `rd.break`.  
2. Remontar el filesystem en modo lectura/escritura:  
   ```bash
   mount -o remount,rw /sysroot
   chroot /sysroot
   passwd root
   touch /.autorelabel
   exit
   reboot
   ```

---

### **Resumen Clave para el Examen RHCSA**  
- **Dominio de LVM**: Creación, expansión y recuperación de volúmenes lógicos.  
- **Firewalld y SELinux**: Configuración básica y solución de conflictos.  
- **Systemd**: Gestión de servicios y diagnóstico con `journalctl`.  
- **Troubleshooting**: Recuperación de contraseña y reparación de filesystems.  

**¡Consejos para el Examen!**  
- Practica en un entorno real o con máquinas virtuales (KVM/VirtualBox).  
- Memoriza rutas clave: `/etc/fstab`, `/etc/default/grub`, `/etc/sysconfig/network-scripts/`.  
- Usa `man -k <keyword>` para buscar páginas de manual relevantes durante el examen.


