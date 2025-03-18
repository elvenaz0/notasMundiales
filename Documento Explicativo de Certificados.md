
---

## 1. Por qué no existen certificados eternos

Todos los certificados de seguridad (SSL/TLS) llevan incorporada una fecha de expiración. Es un requisito de seguridad que evita el uso de certificados potencialmente comprometidos o caducados. Sin embargo, podemos configurarlos para que se renueven automáticamente, de modo que tengas tu sitio seguro siempre, sin tener que preocuparte manualmente de las fechas de caducidad.

---

## 2. Opciones de certificados en Azure

### 2.1 Certificado administrado por Azure (App Service Managed Certificate)

- **Qué es:**  
    Es un certificado gratuito que Azure emite y renueva automáticamente.
- **Ventajas:**
    - No pagas nada adicional (lo incluye el servicio).
    - Se renueva solo, sin intervención.
- **Limitaciones:**
    - Solo funciona para _subdominios_ (ejemplo: `app.midominio.com`), no para el dominio raíz (`midominio.com`).
    - No admite certificados comodín (wildcard), por ejemplo, `*.midominio.com`.
- **Costos:**
    - **Gratis** en el nivel de App Service que incluya la funcionalidad de dominio personalizado.
- **Para quién es ideal:**
    - Pequeñas aplicaciones, entornos de desarrollo o escenarios donde usar subdominios está bien.

### 2.2 Certificado comprado a través de Azure (App Service Certificate)

- **Qué es:**  
    Azure te permite **comprar** un certificado (por un año, dos años, etc.) y almacenarlo automáticamente en un “Azure Key Vault” para luego aplicarlo a tu sitio.
- **Ventajas:**
    - Puede cubrir dominios raíz, subdominios e incluso certificados comodín.
    - Permite configurar renovación automática (dependiendo de la CA o emisor).
    - Se integra fácilmente con App Service.
- **Limitaciones:**
    - Tiene un **costo anual** de renovación (varía según el tipo de certificado: estándar, comodín, etc.).
    - Necesitas un nivel de App Service que permita dominios personalizados y un Key Vault asociado (que tiene un costo bajo mensual, generalmente unos pocos dólares).
- **Costos aproximados:**
    - Certificados estándar: desde **USD $50** al año (aprox.)
    - Certificados comodín: desde **USD $200**–$300 al año (aprox.)
    - Key Vault (almacenamiento y administración): **desde ~USD $0.75** al mes en el nivel Standard.
- **Para quién es ideal:**
    - Empresas que requieran un certificado confiable para el dominio raíz (`midominio.com`) y subdominios, o un comodín que cubra todo (`*.midominio.com`), con soporte y validez reconocida por la mayoría de navegadores.

### 2.3 Certificado propio (Bring Your Own Certificate)

- **Qué es:**  
    Tú obtienes el certificado con un proveedor externo (por ejemplo, GoDaddy, DigiCert, GlobalSign, Let’s Encrypt, etc.) y lo **subes a Azure** manualmente.
- **Ventajas:**
    - Control total sobre el proveedor y tipo de certificado.
    - Puedes elegir certificados gratuitos (Let’s Encrypt) o certificados de pago con validación extendida (EV).
- **Limitaciones:**
    - Necesitas renovarlo y volver a subirlo manualmente a Azure, a menos que implementes un proceso de automatización.
    - El costo depende del proveedor externo.
- **Costos aproximados:**
    - Let’s Encrypt: gratuito, se renueva cada 90 días. Necesita un mecanismo de automatización (generalmente scripts o extensiones en Azure) para que no tengas que hacerlo a mano.
    - Otros proveedores comerciales: entre **USD $50** y varios cientos de dólares al año, según el tipo de certificado.
- **Para quién es ideal:**
    - Quien ya tenga un certificado emitido por su proveedor de confianza.
    - Quien desee usar certificados gratuitos (Let’s Encrypt) y esté dispuesto a configurar la automatización.

---

## 3. ¿Cuál es la opción adecuada?

- **Buscas la opción más sencilla y sin costos extra**  
    → Usa el **Certificado Administrado por Azure** (App Service Managed) si tu dominio es un subdominio y no necesitas comodín.
- **Quieres cubrir el dominio raíz o wildcard (“*.tudominio.com”) con un manejo automático**  
    → Compra un **App Service Certificate** e intégralo con Key Vault (o configura la renovación automática con tu CA).
- **Ya tienes un certificado de otra entidad certificadora**  
    → “Súbelo” (Bring Your Own Certificate) y asegúrate de crear una automatización de renovación (especialmente en el caso de Let’s Encrypt).

---

## 4. Conclusión

Si bien no hay un “certificado infinito” (todos tienen fecha de caducidad), existen mecanismos de **renovación automática** que, de cara al cliente, funcionan como si el certificado fuera “eterno”. Dependiendo de tus necesidades (tipo de dominio, costos, validación y facilidad de gestión), puedes elegir la opción que mejor se ajuste a tu proyecto.

- **Costos de referencia**:
    - **Certificado administrado**: Gratis.
    - **Certificado comprado**: Entre USD ~~$50 y $300 anuales, más un costo bajo mensual por Key Vault (~~$1 o menos), si se requiere.
    - **Certificado propio**: Puede ser gratuito (Let’s Encrypt) o depender de un proveedor (costos variables); la clave es automatizar la renovación.

De esta manera, tu sitio siempre se mantendrá seguro y con el candado verde (HTTPS) sin que tengas que preocuparte por las fechas de expiración manualmente.