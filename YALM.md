**Resumen de la documentación relevante de YAML**  
*(Enfocado en su uso con Ansible y automatización)*  

---

### **1. ¿Qué es YAML?**  
- **YAML Ain't Markup Language**: Formato de serialización de datos legible para humanos.  
- **Uso en Ansible**: Define playbooks, inventarios, variables y estructuras de datos.  

---

### **2. Sintaxis Básica**  
#### **Indentación**  
- **Espacios, no tabs**: Usa 2 espacios por nivel (estándar en Ansible).  
- **Jerarquía**: Define estructuras anidadas (ej: listas dentro de diccionarios).  

#### **Comentarios**  
- Comienza con `#`:  
  ```yaml
  # Esto es un comentario
  key: value  # Comentario al final de la línea
  ```

---

### **3. Tipos de Datos Principales**  
#### **Escalares**  
- **Strings**:  
  ```yaml
  name: "Juan Pérez"  # Comillas opcionales (necesarias si hay caracteres especiales).
  ```
- **Números**:  
  ```yaml
  port: 8080
  version: 2.5
  ```
- **Booleanos**:  
  ```yaml
  enabled: true
  active: no  # También se usan yes/no.
  ```

#### **Listas (Secuencias)**  
- Usan guión (`-`):  
  ```yaml
  fruits:
    - Apple
    - Banana
    - Orange
  ```

#### **Diccionarios (Mappings)**  
- Pares `clave: valor`:  
  ```yaml
  user:
    name: juan
    uid: 1001
    shell: /bin/bash
  ```

---

### **4. Estructuras Complejas**  
#### **Listas de Diccionarios**  
```yaml
servers:
  - name: web1
    ip: 192.168.1.10
  - name: db1
    ip: 192.168.1.20
```

#### **Diccionarios de Listas**  
```yaml
config:
  ports:
    - 80
    - 443
  protocols:
    - http
    - https
```

---

### **5. Multi-líneas y Strings Literales**  
#### **Texto Multilínea**  
- `|`: Preserva saltos de línea.  
- `>`: Convierte saltos en espacios.  
```yaml
message: |
  Línea 1
  Línea 2

description: >
  Este texto se
  mostrará en una sola línea.
```

---

### **6. Anclas y Alias (Reusabilidad)**  
- **`&`**: Define un ancla.  
- **`*`**: Referencia un ancla.  
```yaml
defaults: &defaults
  timeout: 30
  retries: 3

server_config:
  <<: *defaults  # Hereda valores de "defaults"
  port: 8080
```

---

### **7. Uso en Ansible**  
#### **Playbooks**  
```yaml
- name: Instalar Apache  # Lista de plays
  hosts: webservers
  tasks:  # Lista de tareas
    - name: Instalar paquete
      ansible.builtin.yum:
        name: httpd
        state: present
```

#### **Variables**  
```yaml
vars:
  http_port: 80
  domains:
    - example.com
    - test.com
```

#### **Plantillas Jinja2**  
```yaml
template: "{{ user.home }}/config.ini"  # Uso de variables en YAML.
```

---

### **8. Errores Comunes**  
1. **Indentación incorrecta**:  
   ```yaml
   tasks:
   - name: Tarea mal indentada  # ¡Error! Debe tener 2 espacios.
     command: echo "Hola"
   ```

2. **Comillas innecesarias/mal usadas**:  
   ```yaml
   msg: "Error: {{ error }}"  # Correcto (variables dentro de comillas).
   ```

3. **Tipos de datos equivocados**:  
   ```yaml
   enabled: "yes"  # ¡Error! Debe ser booleano: yes → true.
   ```

---

### **9. Mejores Prácticas**  
- **Mantenlo simple**: Evita estructuras demasiado anidadas.  
- **Usa `ansible-lint`**: Valida la sintaxis de tus playbooks.  
- **Documenta con comentarios**: Especialmente en variables complejas.  

---

### **10. Quick Reference**  
| **Símbolo** | **Uso**                          |  
|-------------|-----------------------------------|  
| `-`         | Listas.                          |  
| `:`         | Diccionarios.                    |  
| `|`         | Texto multilínea (preserva saltos). |  
| `>`         | Texto multilínea (compacto).     |  
| `#`         | Comentarios.                     |  
| `!!`        | Etiquetas de tipo (ej: `!!str`). |  

---

**Ejemplo Final Integrado (Ansible):**  
```yaml
- name: Configurar servidor web
  hosts: webservers
  vars:
    app_version: "1.4.2"
    ports:
      - 80
      - 443
  tasks:
    - name: Instalar Nginx
      ansible.builtin.yum:
        name: nginx
        state: latest

    - name: Copiar configuración
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
```

**¡Consejo clave!**  
YAML es sensible a la estructura. Usa editores con resaltado YAML (VS Code, Atom) y valida con herramientas como [YAML Lint Online](https://www.yamllint.com/).