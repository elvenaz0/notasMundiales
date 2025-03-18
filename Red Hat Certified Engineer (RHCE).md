**Temario detallado para el Red Hat Certified Engineer (RHCE) - EX294 (RHEL 8/9)**  
*(Enfoque en Automatización con Ansible: Teoría y Ejemplos Prácticos)*  

---

### **1. Gestión de Inventarios Dinámicos y Estáticos**  
**Teoría:**  
- Inventarios estáticos (archivos `.ini` o `.yml`) y dinámicos (scripts que generan JSON).  
- Variables de host y grupo en `host_vars/` y `group_vars/`.  

**Ejemplo práctico:**  
```ini
# Inventario estático (inventario.ini)
[webservers]
web1 ansible_host=192.168.1.10 ansible_user=admin
web2 ansible_host=192.168.1.11

[databases:children]  # Grupo anidado
webservers
```

```bash
# Usar inventario dinámico de AWS EC2:
ansible -i aws_ec2.yml -m ping all
```

---

### **2. Playbooks Avanzados**  
**Teoría:**  
- Estructura de playbooks: `vars`, `tasks`, `handlers`, `tags`, `become`.  
- Estrategias de ejecución: `linear` (por defecto), `free` (ejecución paralela).  

**Ejemplo práctico:**  
```yaml
- name: Configurar servidor web y base de datos
  hosts: webservers
  vars:
    http_port: 8080
  become: yes  # Ejecutar como root
  tasks:
    - name: Instalar Apache
      ansible.builtin.yum:
        name: httpd
        state: latest
      tags: apache

    - name: Iniciar servicio Apache
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: yes
```

---

### **3. Roles y Reutilización de Código**  
**Teoría:**  
- Directorios estándar: `tasks/`, `handlers/`, `templates/`, `vars/`, `defaults/`.  
- Uso de `ansible-galaxy` para crear/esqueleto de roles.  

**Ejemplo práctico:**  
```bash
# Crear estructura de un rol:
ansible-galaxy role init mi_rol

# Playbook que usa un rol:
- name: Aplicar configuración de firewall
  hosts: all
  roles:
    - role: mi_rol
      vars:
        firewall_port: 22
```

---

### **4. Variables y Facts**  
**Teoría:**  
- Variables definidas en inventario, playbooks, roles o registradas con `register`.  
- Facts: Datos del sistema obtenidos con el módulo `setup`.  

**Ejemplo práctico:**  
```yaml
- name: Obtener información del sistema
  hosts: all
  tasks:
    - name: Recolectar facts
      ansible.builtin.setup:

    - name: Mostrar versión del SO
      debug:
        msg: "Sistema operativo: {{ ansible_distribution }} {{ ansible_distribution_version }}"
```

---

### **5. Plantillas Jinja2**  
**Teoría:**  
- Generación dinámica de archivos usando variables, bucles (`{% for %}`) y condicionales (`{% if %}`).  

**Ejemplo práctico (Plantilla `nginx.conf.j2`):**  
```nginx
server {
    listen {{ nginx_port }};
    server_name {{ server_name }};
    root {{ web_root }};
    {% if enable_ssl %}
    ssl_certificate /etc/ssl/{{ cert_name }};
    {% endif %}
}
```

**Playbook asociado:**  
```yaml
- name: Configurar Nginx
  hosts: webservers
  vars:
    nginx_port: 443
    enable_ssl: true
    cert_name: "mi_sitio.crt"
  tasks:
    - ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
```

---

### **6. Manejadores (Handlers)**  
**Teoría:**  
- Tareas que se ejecutan solo cuando son notificadas por cambios en otros tasks.  

**Ejemplo práctico:**  
```yaml
tasks:
  - name: Actualizar configuración de SSH
    ansible.builtin.copy:
      src: sshd_config
      dest: /etc/ssh/sshd_config
    notify: Reiniciar SSH

handlers:
  - name: Reiniciar SSH
    ansible.builtin.service:
      name: sshd
      state: restarted
```

---

### **7. Ansible Vault**  
**Teoría:**  
- Encriptación de datos sensibles (contraseñas, claves API).  

**Ejemplo práctico:**  
```bash
# Crear archivo encriptado:
ansible-vault create secret.yml

# Contenido de secret.yml:
db_password: "P@ssw0rd123"

# Usarlo en un playbook:
- name: Desplegar base de datos
  hosts: databases
  vars_files:
    - secret.yml
  tasks:
    - name: Configurar contraseña de MySQL
      ansible.builtin.shell: echo "{{ db_password }}" | mysql_secure_installation
```

---

### **8. Módulos Esenciales**  
**Teoría y Ejemplos:**  
- **`yum`/`dnf`**: Gestión de paquetes.  
  ```yaml
  - name: Instalar PostgreSQL
    ansible.builtin.yum:
      name: postgresql-server
      state: present
  ```
  
- **`service`**: Control de servicios.  
  ```yaml
  - name: Habilitar MariaDB
    ansible.builtin.service:
      name: mariadb
      enabled: yes
  ```
  
- **`copy`/`template`**: Manejo de archivos.  
- **`user`/`group`**: Administración de usuarios.  

---

### **9. Troubleshooting y Depuración**  
**Teoría:**  
- Opciones de verbosidad (`-v`, `-vv`, `-vvv`).  
- Módulo `debug` para imprimir variables.  

**Ejemplo práctico:**  
```yaml
- name: Depurar variables
  debug:
    var: ansible_facts.memtotal_mb
```

---

### **10. Automatización de Tareas Comunes de RHCSA con Ansible**  
**Ejemplo: Configurar LVM**  
```yaml
- name: Crear volumen lógico
  hosts: storage_servers
  tasks:
    - name: Crear Physical Volume
      ansible.builtin.lvol:
        vg: vg_data
        pvs: /dev/sdb1

    - name: Crear Logical Volume de 10GB
      ansible.builtin.lvol:
        vg: vg_data
        lv: lv_app
        size: 10G

    - name: Formatear como XFS
      ansible.builtin.filesystem:
        fstype: xfs
        dev: /dev/vg_data/lv_app
```

---

### **11. Seguridad con Ansible**  
**Ejemplo: Configurar Firewalld y SELinux**  
```yaml
- name: Asegurar servidores web
  hosts: webservers
  tasks:
    - name: Permitir puerto HTTP en firewalld
      ansible.posix.firewalld:
        port: 80/tcp
        permanent: yes
        state: enabled

    - name: Establecer contexto SELinux para directorio web
      ansible.builtin.sefcontext:
        target: "/var/www/html(/.*)?"
        setype: httpd_sys_content_t
```

---

### **12. Uso de Collections**  
**Teoría:**  
- Módulos de la comunidad (ej: `community.general`, `ansible.posix`).  

**Ejemplo práctico:**  
```yaml
- name: Usar módulo de community.general
  community.general.ufw:
    rule: allow
    port: "{{ http_port }}"
    direction: in
```

---

### **Consejos Clave para el Examen RHCE (EX294)**  
1. **Practica Playbooks Complejos**: Combina roles, handlers y templates en un solo flujo.  
2. **Domina Ansible Vault**: Asegúrate de poder encriptar/desencriptar variables durante el examen.  
3. **Usa `ansible-doc`**: Consulta módulos rápidamente (ej: `ansible-doc yum`).  
4. **Gestión de Errores**: Prueba playbooks con `--check` o `--diff` antes de ejecutarlos.  
5. **Optimiza Tiempo**: Usa `tags` para ejecutar partes específicas del playbook.  

**Ejemplo de Playbook Integrado (Resumen):**  
```yaml
- name: Despliegue completo de aplicación web
  hosts: webservers
  vars_files:
    - vars/secrets.yml
  roles:
    - role: firewall
    - role: apache
    - role: ssl
  tasks:
    - name: Verificar conectividad de la app
      uri:
        url: "http://localhost:{{ http_port }}"
        status_code: 200
```