Para dar de alta un usuario en un servidor Windows y restringir su acceso únicamente a un disco específico, sigue estos pasos:

---

### **1. Crear el Usuario en el Servidor Windows**

Si el servidor está unido a un Active Directory (AD), lo ideal es crear el usuario desde el AD y asignarle los permisos en el servidor. Si es un usuario local, hazlo directamente en el servidor.

#### **Opción 1: Crear Usuario en Active Directory**

Si el usuario debe ser gestionado desde AD:

1. Accede al **Administrador del Servidor** en el Domain Controller (DC).
2. Ve a **Herramientas** > **Usuarios y equipos de Active Directory**.
3. En la Unidad Organizativa (OU) correspondiente, haz clic derecho y selecciona **Nuevo** > **Usuario**.
4. Ingresa los datos del usuario:
    - **Nombre:** Manuel Bartlett
    - **Usuario:** MBartlett
    - **Contraseña:** MBartlett1936 (forzar cambio en primer inicio si es necesario)
5. Configura que la contraseña no expire (si el cliente lo requiere).
6. Agrega al usuario a grupos específicos si es necesario.

---

#### **Opción 2: Crear Usuario Local en el Servidor**

Si el servidor no está en un dominio AD, crea un usuario local:

1. Conéctate al servidor **Cliente-Contpaq** (por RDP o en consola).
2. Abre **Administración de equipos** (`compmgmt.msc`).
3. Ve a **Usuarios y grupos locales** > **Usuarios**.
4. Clic derecho en **Usuarios** > **Nuevo usuario**.
5. Ingresa:
    - **Nombre:** Manuel Bartlett
    - **Usuario:** MBartlett
    - **Contraseña:** MBartlett1936
6. Desmarca "El usuario debe cambiar la contraseña en el siguiente inicio de sesión" si no es necesario.
7. Asegúrate de que **"La contraseña nunca expira"** esté habilitada si el cliente lo requiere.
8. Clic en **Crear** y luego **Cerrar**.

---

### **2. Crear y Asignar el Disco al Usuario**

Si el usuario solo debe acceder a un disco específico, debes configurar los permisos sobre la unidad.

#### **Opción 1: Crear un Nuevo Disco Virtual (VHD)**

Si necesitas un disco exclusivo para este usuario:

1. Abre **Administración de discos** (`diskmgmt.msc`).
2. Clic en **Acción** > **Crear VHD**.
3. Configura:
    - Ubicación: `C:\Discos\MBartlett.vhd`
    - Tamaño: Según lo solicitado por el cliente.
    - Tipo: **Dinamicamente expandible** o **Tamaño fijo**.
4. Inicializa el disco, crea un volumen y formatéalo en NTFS.
5. Asigna una letra de unidad (ej. `E:\`).
6. Monta el disco en cada inicio configurando `diskpart` si es necesario.

---

#### **Opción 2: Restringir Acceso a una Carpeta en un Disco Existente**

Si el usuario solo necesita acceso a una carpeta en un disco ya existente:

1. En el disco deseado (ej. `D:\`), crea una carpeta: `D:\ManuelBartlett`.
2. Clic derecho en la carpeta > **Propiedades** > **Seguridad**.
3. Clic en **Editar** > **Agregar**.
4. Ingresa el usuario `MBartlett`, clic en **Aceptar**.
5. En **Permisos**, desmarca "Heredar permisos" y asegúrate de que:
    - Solo tenga acceso de **Lectura/Escritura** (si aplica).
    - No tenga permisos de acceso a otras carpetas o discos.

---

### **3. Prueba de Acceso**

1. Conéctate con las credenciales de `MBartlett`.
2. Verifica que el usuario solo pueda ver su disco (`E:\` o `D:\ManuelBartlett`).
3. Asegúrate de que no tenga acceso a otras unidades (`C:\`, `D:\`).
4. Si es necesario, oculta otras unidades mediante **Políticas de Grupo (GPO)**.

---

### **4. Confirmar con el Cliente**

- Informa que el usuario ha sido creado.
- Confirma si necesita acceso remoto (RDP) o solo acceso local.
- Asegúrate de que el usuario pueda iniciar sesión sin problemas.
