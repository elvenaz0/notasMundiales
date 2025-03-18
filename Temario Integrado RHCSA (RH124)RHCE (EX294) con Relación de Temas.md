

**Temario Integrado: RHCSA (RH124) + RHCE (EX294) con Relación de Temas**  
*(Basado en RHEL 8/9 y Automatización con Ansible)*  

---

### **1. Gestión de Usuarios y Grupos**  
- **RHCSA**:  
  - Crear, modificar y eliminar usuarios/grupos (`useradd`, `usermod`, `groupadd`).  
  - Permisos sudo (`visudo`, `/etc/sudoers`).  
- **RHCE**:  
  - Automatizar con Ansible:  
    ```yaml
    - name: Crear usuario
      ansible.builtin.user:
        name: juan
        group: developers
        state: present
    ```

---

### **2. Administración de Almacenamiento**  
- **RHCSA**:  
  - Particiones, sistemas de archivos (`fdisk`, `mkfs`, `mount`).  
  - LVM: Crear/expandir volúmenes (`pvcreate`, `lvextend`).  
- **RHCE**:  
  - Automatizar LVM con Ansible:  
    ```yaml
    - name: Crear LV
      community.general.lvol:
        vg: vg_data
        lv: lv_app
        size: 10G
    ```

---

### **3. Configuración de Redes**  
- **RHCSA**:  
  - Configurar IP estática con `nmcli` o archivos en `/etc/sysconfig/network-scripts/`.  
  - Diagnóstico básico (`ping`, `ip addr`, `ss`).  
- **RHCE**:  
  - Automatizar redes con Ansible:  
    ```yaml
    - name: Configurar IP
      ansible.posix.nmcli:
        conn_name: eth0
        type: ethernet
        ip4: 192.168.1.100/24
        gw4: 192.168.1.1
    ```

---

### **4. Seguridad**  
- **RHCSA**:  
  - Firewalld: Zonas, servicios (`firewall-cmd`).  
  - SELinux: Modos, contextos (`getenforce`, `chcon`).  
- **RHCE**:  
  - Automatizar seguridad:  
    ```yaml
    - name: Permitir puerto HTTP
      ansible.posix.firewalld:
        port: 80/tcp
        state: enabled
    ```

---

### **5. Gestión de Paquetes y Servicios**  
- **RHCSA**:  
  - Instalar/actualizar paquetes con `dnf`.  
  - Administrar servicios con `systemctl`.  
- **RHCE**:  
  - Automatizar con Ansible:  
    ```yaml
    - name: Instalar Apache
      ansible.builtin.yum:
        name: httpd
        state: latest
    - name: Iniciar servicio
      ansible.builtin.service:
        name: httpd
        state: started
    ```

---

### **6. Automatización con Ansible (RHCE)**  
- **Inventarios**:  
  - Estáticos vs. dinámicos, grupos y variables (`inventory.ini`, `group_vars/`).  
- **Playbooks**:  
  - Sintaxis YAML, tareas, handlers, tags.  
  - Ejemplo:  
    ```yaml
    - hosts: webservers
      tasks:
        - name: Copiar archivo
          ansible.builtin.copy:
            src: app.conf
            dest: /etc/app.conf
    ```
- **Roles**:  
  - Estructura de directorios (`tasks/`, `handlers/`, `templates/`).  
- **Templates Jinja2**:  
  - Generar archivos dinámicos con variables.  

---

### **7. Gestión de Logs y Troubleshooting**  
- **RHCSA**:  
  - Herramientas: `journalctl`, `/var/log/`.  
  - Recuperar contraseña root (modo single-user).  
- **RHCE**:  
  - Depurar playbooks:  
    ```bash
    ansible-playbook playbook.yml -vvv  # Verbosidad aumentada
    ```
    ```yaml
    - name: Verificar variable
      debug:
        var: ansible_facts.os_family
    ```

---

### **8. Tareas Programadas**  
- **RHCSA**:  
  - `cron` y `at` para tareas recurrentes/puntuales.  
- **RHCE**:  
  - Automatizar cron con Ansible:  
    ```yaml
    - name: Programar backup
      ansible.builtin.cron:
        name: "Backup diario"
        job: "/opt/scripts/backup.sh"
        hour: 2
        minute: 0
    ```

---

### **9. Configuración de Sistemas de Archivos**  
- **RHCSA**:  
  - Montaje persistente (`/etc/fstab`).  
  - Cuotas de disco (`xfs_quota`).  
- **RHCE**:  
  - Automatizar montajes:  
    ```yaml
    - name: Montar filesystem
      ansible.builtin.mount:
        path: /data
        src: /dev/vg_data/lv_app
        fstype: xfs
        state: mounted
    ```

---

### **10. Integración de Habilidades (RHCSA + RHCE)**  
| **Tema**              | **RHCSA (Manual)**       | **RHCE (Automatizado)**       |  
|-----------------------|--------------------------|-------------------------------|  
| Instalar Apache       | `dnf install httpd`      | Módulo `yum` en playbook.     |  
| Configurar Firewall   | `firewall-cmd --add-port=80/tcp` | Módulo `firewalld` de Ansible. |  
| Crear Usuario         | `useradd juan`           | Módulo `user` de Ansible.     |  

---

### **Relación Clave Entre Certificaciones**  
1. **RHCSA como Base**:  
   - Sin habilidades manuales (RHCSA), no se puede automatizar eficientemente (RHCE).  
   - Ejemplo: Para automatizar LVM con Ansible, debes entender cómo funciona LVM manualmente.  

2. **RHCE como Evolución**:  
   - Todo lo aprendido en RHCSA se escala con Ansible para gestionar múltiples sistemas.  
   - Ejemplo: En RHCSA configuras un servidor web; en RHCE automatizas su despliegue en 100 nodos.  

---

### **Recursos Recomendados**  
- **RHCSA**: Laboratorios prácticos de Red Hat (curso RH124).  
- **RHCE**: Curso RH294 (Ansible para RHEL).  
- **Herramientas**:  
  - Máquinas virtuales (KVM, VirtualBox).  
  - Entorno de pruebas con Vagrant o AWS EC2.  

**¡Consejo Final!**  
- Domina primero RHCSA: La automatización (RHCE) requiere entender los fundamentos.  
- Practica playbooks que repliquen tareas manuales de RHCSA.


