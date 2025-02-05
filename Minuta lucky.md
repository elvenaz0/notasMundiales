### **Minuta de Configuración de Acceso Seguro mediante SSO y Conexión a RDS y S3**

**Fecha:** [29-01-2025]    
**Cliente:** [Mario Gonzalez]    
**Proyecto:** Configuración de acceso seguro a instancia EC2 para conexión con RDS y S3    
**Responsable Técnico:** [Leonardo Covarrubias]    
**Participantes:** [Iván Ugalde, Raul Pallas]  

---

#### **Objetivo:**  
El objetivo de esta minuta es documentar los pasos y consideraciones necesarias para configurar un acceso seguro mediante **AWS Single Sign-On (SSO)** a una instancia EC2, permitiendo la conexión con **Amazon RDS** y **Amazon S3** de manera segura y eficiente.

---

### **1. Configuración de AWS Single Sign-On (SSO)**

**Descripción:**    
Se configurará AWS SSO para permitir el acceso seguro a la instancia EC2 mediante credenciales temporales, siguiendo las mejores prácticas de seguridad.

**Pasos realizados o a realizar:**    
1. Configuración del proveedor de identidad (IdP) en AWS SSO (por ejemplo, Azure AD, Okta, etc.).    
2. Creación de usuarios y grupos en AWS SSO.    
3. Asignación de permisos específicos a los usuarios/grupos para acceder a los servicios de AWS necesarios (RDS y S3).    
4. Generación de credenciales temporales para los usuarios/grupos, las cuales se utilizarán para acceder a la instancia EC2.  

---



### **2. Creación y Asignación de Roles de IAM**

**Descripción:**    
Se creará un rol de IAM con los permisos mínimos necesarios para acceder a RDS y S3, y se asociará a la instancia EC2.

---

### **3. Configuración de la Conexión a Amazon RDS**

**Descripción:**    
Se configurará la instancia EC2 para conectarse de manera segura a la base de datos RDS.

**Pasos realizados o a realizar:**    
3. Verificación de que la instancia EC2 y la base de datos RDS estén en la misma VPC.    
4. Configuración del grupo de seguridad de RDS para permitir el tráfico desde la instancia EC2.    
5. Conexión a la base de datos RDS utilizando las credenciales temporales proporcionadas por AWS SSO.  

---

### **4. Configuración de la Conexión a Amazon S3**

**Descripción:**    
Se configurará la instancia EC2 para interactuar con Amazon S3 de manera segura.

**Pasos realizados o a realizar:**    
1. Configuración de las credenciales temporales proporcionadas por AWS SSO en la instancia EC2.    
2. Uso del SDK de AWS o la CLI de AWS para realizar operaciones en S3 (subir, descargar, listar objetos).    
3. Verificación de que las operaciones en S3 se realicen correctamente y de manera segura.  

---

### **5. Consideraciones de Seguridad**

**Descripción:**    
Se implementarán medidas de seguridad para garantizar que el acceso a los recursos de AWS sea seguro y esté alineado con las mejores prácticas.

**Medidas implementadas:**    
- Uso de credenciales temporales proporcionadas por AWS SSO.    
- Restricción de permisos al mínimo necesario (principio de menor privilegio).    
- Configuración de grupos de seguridad para restringir el acceso a RDS.    
- Monitoreo y auditoría de accesos mediante **AWS CloudTrail**.  

---

### **6. Próximos Pasos**

**Descripción:**    
Se detallan las acciones futuras para completar la configuración y garantizar su correcto funcionamiento.

**Acciones:**    
4. Revisión y prueba de la configuración por parte del equipo técnico.    
5. Documentación adicional y capacitación para los usuarios finales.    
6. Monitoreo continuo y ajustes de seguridad según sea necesario.  

---

### **7. Responsabilidades**

- **Equipo Técnico:**    
  - Configuración de AWS SSO, IAM, RDS y S3.    
  - Verificación y pruebas de la configuración.    
  - Entrega de documentación y capacitación.  

- **Cliente:**    
  - Proporcionar acceso a la consola de AWS y credenciales necesarias.    
  - Revisar y aprobar la configuración realizada.    
  - Notificar cualquier incidencia o requerimiento adicional.  

---

### **8. Firma de Conformidad**

**Cliente:**  lucky intelligence  
Nombre: Mario Gonzalez
Firma: ____________________________    
Fecha: 31-01-25

**Responsable Técnico:**    
Nombre: Leonardo Covarrubias
Participantes: Iván Ugalde - Raul Pallas
Firma: ____________________________    
Fecha: 31-01-25  

---
