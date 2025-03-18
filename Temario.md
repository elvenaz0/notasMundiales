
A continuación, encontrarás un temario resumido de los objetivos clave que se cubren en la certificación **Red Hat Certified Engineer (RHCE) para RHEL 8**, también conocida como examen EX294. Estos temas se basan en la información oficial que Red Hat proporciona sobre la preparación y el enfoque del examen:

1. **[[Automatización con Ansible]]**
    
    - Fundamentos de Ansible: instalación, configuración y uso de inventarios.
    - Escribir y ejecutar playbooks para automatizar la configuración y el despliegue de sistemas.
    - Uso y creación de roles de Ansible para organizar y reutilizar configuraciones.
    - Variables, plantillas (Jinja2) y handlers para la automatización de tareas específicas.
    - Gestión de credenciales y cifrado seguro con Ansible Vault.
2. **Gestión de sistemas Linux**
    
    - Configuración de red (NetworkManager, DNS, resolución de nombres, etc.).
    - Administración de almacenamiento local y volúmenes lógicos (LVM).
    - Configuración de sistemas de archivos (ext4, XFS), puntos de montaje y permisos.
    - Creación y gestión de usuarios y grupos, incluidas políticas de contraseña.
    - Configuración de programadores de tareas (cron, systemd timers).
3. **Servicios y seguridad en RHEL 8**
    
    - Configuración y administración de firewalld: zonas, servicios y reglas personalizadas.
    - SELinux (Security-Enhanced Linux): modos de operación, contexto de archivos, permisos.
    - Manejo de suscripciones y repositorios en Red Hat Enterprise Linux.
    - Supervisión de procesos y administración de software (dnf, módulos de aplicación).
4. **Contenedores y virtualización básica**
    
    - Uso de herramientas de contenedores (podman, buildah) para construir y gestionar contenedores ligeros.
    - Implementación de contenedores y gestión de imágenes locales/remotas.
    - Conocimientos básicos de virtualización según sea relevante (KVM, libvirt), aunque el foco principal es la automatización y los contenedores.
5. **Tareas de red avanzadas y servicios complementarios**
    
    - Configuración avanzada de red: bonding, teaming, bridging.
    - Ajustes de rendimiento y tunning del sistema para distintos escenarios.
    - Creación y configuración de servicios críticos (por ejemplo, servidores web o de base de datos), muchas veces a través de Ansible.
6. **Prácticas y troubleshooting**
    
    - Interpretar y resolver errores en playbooks de Ansible y configuraciones de RHEL.
    - Uso de herramientas de diagnóstico (journalctl, registros del sistema, systemctl).
    - Aplicar metodologías de resolución de problemas en entornos de producción.
7. **Implementación de Roles de Sistema (RHEL System Roles)**
    
    - Uso de roles predefinidos que Red Hat proporciona para automatizar configuraciones comunes (network, SELinux, storage, etc.) de manera estandarizada.

---

### Enfoque práctico y consejos de preparación

- **Enfócate en la automatización:** El mayor cambio en RHCE a partir de RHEL 8 es el énfasis en Ansible. Dominar los conceptos de Ansible y practicar playbooks es clave.
- **Laboratorio práctico:** Configura un entorno de práctica con máquinas virtuales o contenedores para ensayar tareas de automatización y administración de servicios.
- **Documentación oficial:** Utiliza la [documentación de Red Hat](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/) para repasar características y comandos específicos de RHEL 8.
- **Roles y escenarios reales:** Practica la creación de roles Ansible y la automatización de configuraciones en escenarios similares a entornos de producción.

Este temario te brinda una visión general de las áreas principales que cubrirás en la preparación para el **Red Hat Certified Engineer en RHEL 8 (EX294)**. Revisa en detalle las guías y los materiales de estudio oficiales de Red Hat para complementar estos puntos y asegurarte de abarcar todos los objetivos de la certificación.