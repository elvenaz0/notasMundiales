**Temario del curso Red Hat System Administration I (RH124)**  
*(Basado en RHEL 8/9)*  

---

### **1. Introducción a la línea de comandos de Linux**  
- **Teoría**:  
  - Acceso al sistema mediante terminal.  
  - Comandos básicos: `ls`, `pwd`, `cd`, `man`, `--help`.  
  - Navegación en el sistema de archivos (FHS).  
- **Práctica**:  
  ```bash
  ls -l /var/log  # Listar archivos en /var/log con detalles.
  man ls          # Consultar el manual del comando "ls".
  ```

---

### **2. Gestión de archivos y directorios**  
- **Teoría**:  
  - Operaciones básicas: crear, copiar, mover y eliminar archivos (`touch`, `cp`, `mv`, `rm`).  
  - Búsqueda de archivos: `find`, `locate`.  
- **Práctica**:  
  ```bash
  mkdir ~/proyecto  # Crear directorio.
  find /home -name "*.txt"  # Buscar archivos .txt en /home.
  ```

---

### **3. Edición de archivos de texto**  
- **Teoría**:  
  - Editores de texto: `nano`, `vim` (modos básicos).  
  - Redirección de entrada/salida (`>`, `>>`, `|`).  
- **Práctica**:  
  ```bash
  echo "Hola, mundo" > saludo.txt  # Crear archivo con contenido.
  vim saludo.txt                   # Editar archivo con Vim.
  ```

---

### **4. Administración de usuarios y grupos**  
- **Teoría**:  
  - Archivos clave: `/etc/passwd`, `/etc/shadow`, `/etc/group`.  
  - Comandos: `useradd`, `usermod`, `passwd`, `groupadd`.  
- **Práctica**:  
  ```bash
  sudo useradd -m usuario1      # Crear usuario con directorio home.
  sudo passwd usuario1          # Establecer contraseña.
  sudo groupadd desarrolladores # Crear grupo.
  ```

---

### **5. Permisos de archivos y directorios**  
- **Teoría**:  
  - Permisos POSIX: lectura (r), escritura (w), ejecución (x).  
  - Comandos: `chmod`, `chown`, `umask`.  
- **Práctica**:  
  ```bash
  chmod 755 script.sh        # Dar permisos rwxr-xr-x.
  chown usuario1:grupo1 archivo.txt  # Cambiar dueño y grupo.
  ```

---

### **6. Gestión de procesos y servicios**  
- **Teoría**:  
  - Comandos: `ps`, `top`, `kill`, `systemctl`.  
  - Servicios con systemd: inicio, detención y estado.  
- **Práctica**:  
  ```bash
  systemctl start httpd      # Iniciar Apache.
  systemctl enable httpd     # Habilitar al inicio.
  ps aux | grep httpd        # Ver procesos de Apache.
  ```

---

### **7. Configuración de redes básica**  
- **Teoría**:  
  - Configuración IP estática/dinámica con `nmcli`.  
  - Verificación de conectividad: `ping`, `ip addr`, `ss`.  
- **Práctica**:  
  ```bash
  nmcli con mod eth0 ipv4.addresses 192.168.1.50/24  # IP estática.
  nmcli con up eth0                # Activar conexión.
  ping 8.8.8.8                     # Probar conectividad.
  ```

---

### **8. Administración de almacenamiento**  
- **Teoría**:  
  - Particiones con `fdisk`/`gdisk`.  
  - Formateo y montaje (`mkfs`, `mount`, `/etc/fstab`).  
- **Práctica**:  
  ```bash
  sudo fdisk /dev/sdb          # Crear partición.
  sudo mkfs.xfs /dev/sdb1      # Formatear como XFS.
  sudo mount /dev/sdb1 /mnt    # Montar temporalmente.
  ```

---

### **9. Instalación de software con DNF/YUM**  
- **Teoría**:  
  - Repositorios, instalación/actualización de paquetes.  
  - Búsqueda y gestión de dependencias.  
- **Práctica**:  
  ```bash
  sudo dnf install httpd       # Instalar Apache.
  sudo dnf update              # Actualizar todos los paquetes.
  sudo dnf search python3      # Buscar paquetes.
  ```

---

### **10. Seguridad básica**  
- **Teoría**:  
  - Firewall con `firewalld` (zonas, servicios).  
  - SSH: Acceso remoto seguro.  
- **Práctica**:  
  ```bash
  sudo firewall-cmd --permanent --add-service=http  # Permitir HTTP.
  sudo firewall-cmd --reload                        # Aplicar cambios.
  ssh usuario1@192.168.1.10        # Conectarse a un servidor remoto.
  ```

---

### **11. Gestión de logs y troubleshooting**  
- **Teoría**:  
  - Herramientas: `journalctl`, `/var/log/`.  
  - Diagnóstico de problemas de arranque.  
- **Práctica**:  
  ```bash
  journalctl -u httpd --since "today"  # Ver logs de Apache.
  journalctl -p err -b                # Errores desde el último arranque.
  ```

---

### **12. Automatización de tareas**  
- **Teoría**:  
  - Programación de tareas con `cron` y `at`.  
- **Práctica**:  
  ```bash
  crontab -e  # Editar tareas programadas (ej: 0 3 * * * /ruta/backup.sh).
  at 14:30    # Programar targa puntual.
  ```

---

### **Resumen del Curso**  
- **Enfoque práctico**: Dominio de la línea de comandos y tareas esenciales de administración.  
- **Preparación para RHCSA**: Base para la certificación Red Hat Certified System Administrator.  
- **Habilidades clave**:  
  - Gestión de usuarios, permisos y almacenamiento.  
  - Configuración de redes y servicios.  
  - Resolución de problemas básicos.  

**¡Consejos para el curso!**  
- Practica en un entorno de laboratorio (máquina virtual o servidor real).  
- Usa `man` y `--help` para explorar opciones de comandos.  
- Documenta tus configuraciones para referencia futura.