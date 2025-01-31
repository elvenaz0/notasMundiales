
## 1. Crear un nuevo usuario IAM
Para crear un usuario en AWS Identity and Access Management (IAM), sigue estos pasos:

1. Inicia sesión en la [Consola de Administración de AWS](https://aws.amazon.com/console/).
2. En el panel de navegación, selecciona **IAM**.
3. En el menú lateral izquierdo, haz clic en **Usuarios**.
4. Selecciona **Agregar usuario**.
5. Introduce el **nombre del usuario**.
6. Selecciona el **tipo de acceso**:
   - **Acceso programático**: Si el usuario utilizará CLI, SDK o API.
   - **Acceso a la Consola de AWS**: Si el usuario iniciará sesión en la consola web.
7. Si seleccionaste acceso a la consola, define una **contraseña**.
8. Haz clic en **Siguiente** para proceder con los permisos.

---

## 2. Agregar permisos desde otro usuario existente
Si deseas copiar los permisos de otro usuario ya existente:

1. En la sección **Permisos**, selecciona **Copiar permisos de un usuario existente**.
2. Busca el usuario del cual deseas copiar los permisos.
3. Selecciónalo y confirma la asignación de permisos.
4. Haz clic en **Siguiente** y revisa los detalles.
5. Finaliza haciendo clic en **Crear usuario**.

---

## 3. Agregar permisos administrados por AWS
Los permisos administrados por AWS son políticas predefinidas que puedes asignar al usuario. Para agregar estos permisos:

6. En la consola de **IAM**, ve a la sección **Usuarios**.
7. Selecciona el usuario al que deseas agregar permisos.
8. Dirígete a la pestaña **Permisos**.
9. Haz clic en **Agregar permisos** > **Adjuntar políticas existentes directamente**.
10. En la barra de búsqueda, busca la política administrada que necesitas, como:
   - `AdministratorAccess` (Acceso total)
   - `AmazonS3FullAccess` (Acceso completo a S3)
   - `AmazonEC2ReadOnlyAccess` (Acceso de solo lectura a EC2)
11. Selecciona la política y haz clic en **Adjuntar políticas**.

---

## 4. Validar la configuración
Una vez creado el usuario y asignados los permisos:

12. **Revisa la configuración** en la sección de **Usuarios**.
13. Verifica que el usuario tiene el **tipo de acceso** correcto.
14. Confirma que las **políticas** asignadas son las adecuadas.
15. Si es un acceso a la consola, comparte con el usuario su **URL de inicio de sesión**, usuario y contraseña.

---

## 5. Consideraciones de seguridad
- **Uso de MFA**: Habilita la autenticación multifactor (MFA) para mayor seguridad.
- **Principio de privilegios mínimos**: Asigna solo los permisos necesarios.
- **Rotación de credenciales**: Si usa acceso programático, revisa y rota credenciales periódicamente.

---

Siguiendo estos pasos, habrás creado un usuario IAM con los permisos necesarios en AWS.
