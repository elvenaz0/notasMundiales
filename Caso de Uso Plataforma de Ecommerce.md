### **Caso de Uso: Plataforma de E-commerce**

#### **Dominio 1: Diseñar Arquitecturas Resilientes**

**1.1 - Diseñar una solución de arquitectura de múltiples capas**  
- **Servicios de AWS**:  
  - **Amazon EC2**: Para servidores web (capa de presentación).  
  - **Amazon RDS**: Para la base de datos (capa de datos).  
  - **Elastic Load Balancer (ELB)**: Para distribuir el tráfico entre las instancias EC2.  
- **Ejemplo**:  
  - La capa de presentación (frontend) se ejecuta en instancias EC2 detrás de un ELB.  
  - La capa de aplicación (backend) se conecta a una base de datos RDS (MySQL o PostgreSQL).  

**1.2 - Diseñar arquitecturas altamente disponibles y/o tolerantes a fallos**  
- **Servicios de AWS**:  
  - **Auto Scaling Groups**: Para escalar automáticamente las instancias EC2 según la demanda.  
  - **Multi-AZ (RDS)**: Para replicar la base de datos en múltiples zonas de disponibilidad.  
- **Ejemplo**:  
  - Configura Auto Scaling para agregar instancias EC2 durante picos de tráfico (ej. Black Friday).  
  - Usa RDS con Multi-AZ para garantizar que la base de datos esté disponible incluso si falla una AZ.  

**1.3 - Diseñar mecanismos de desacoplamiento usando servicios de AWS**  
- **Servicios de AWS**:  
  - **Amazon SQS (Simple Queue Service)**: Para desacoplar componentes de la aplicación.  
  - **Amazon SNS (Simple Notification Service)**: Para notificaciones en tiempo real.  
- **Ejemplo**:  
  - Cuando un usuario realiza una compra, se envía un mensaje a una cola SQS para procesar el pedido de forma asíncrona.  
  - SNS notifica al equipo de logística cuando el pedido está listo para ser enviado.  

**1.4 - Elegir almacenamiento resiliente**  
- **Servicios de AWS**:  
  - **Amazon S3**: Para almacenar imágenes de productos y backups.  
  - **Amazon EFS**: Para almacenamiento compartido entre instancias EC2.  
- **Ejemplo**:  
  - Las imágenes de los productos se almacenan en S3 con versionado habilitado para recuperación en caso de eliminación accidental.  

---

#### **Dominio 2: Diseñar Arquitecturas de Alto Rendimiento**

**2.1 - Identificar soluciones de cómputo elásticas y escalables para una carga de trabajo**  
- **Servicios de AWS**:  
  - **AWS Lambda**: Para funciones sin servidor que escalan automáticamente.  
  - **Amazon EC2 Auto Scaling**: Para ajustar la capacidad de las instancias.  
- **Ejemplo**:  
  - Usa Lambda para procesar pagos o enviar correos electrónicos de confirmación sin gestionar servidores.  

**2.2 - Seleccionar soluciones de almacenamiento de alto rendimiento y escalables**  
- **Servicios de AWS**:  
  - **Amazon DynamoDB**: Para bases de datos NoSQL de baja latencia.  
  - **Amazon S3 Intelligent-Tiering**: Para almacenamiento optimizado en costos y rendimiento.  
- **Ejemplo**:  
  - Usa DynamoDB para almacenar datos de sesión de usuarios y carritos de compra.  

**2.3 - Seleccionar soluciones de redes de alto rendimiento**  
- **Servicios de AWS**:  
  - **Amazon CloudFront**: Para entrega de contenido estático y dinámico con baja latencia.  
  - **AWS Global Accelerator**: Para mejorar la disponibilidad y rendimiento de la aplicación.  
- **Ejemplo**:  
  - Usa CloudFront para servir imágenes y contenido estático desde Edge Locations cercanas a los usuarios.  

**2.4 - Elegir soluciones de bases de datos de alto rendimiento**  
- **Servicios de AWS**:  
  - **Amazon Aurora**: Para bases de datos relacionales de alto rendimiento.  
  - **Amazon ElastiCache**: Para almacenamiento en caché de consultas frecuentes.  
- **Ejemplo**:  
  - Usa Aurora para la base de datos principal y ElastiCache (Redis) para almacenar en caché resultados de consultas frecuentes (ej. productos populares).  

---

#### **Dominio 3: Diseñar Aplicaciones y Arquitecturas Seguras**

**3.1 - Diseñar acceso seguro a recursos de AWS**  
- **Servicios de AWS**:  
  - **IAM (Identity and Access Management)**: Para gestionar permisos de usuarios y roles.  
  - **AWS Organizations**: Para gestionar múltiples cuentas con políticas centralizadas.  
- **Ejemplo**:  
  - Usa IAM para restringir el acceso a la base de datos RDS solo a las instancias EC2 de la capa de aplicación.  

**3.2 - Diseñar niveles de aplicación seguros**  
- **Servicios de AWS**:  
  - **AWS WAF (Web Application Firewall)**: Para proteger la aplicación web de ataques comunes.  
  - **AWS Shield**: Para protección contra DDoS.  
- **Ejemplo**:  
  - Configura WAF para bloquear solicitudes maliciosas (ej. SQL injection) y Shield para proteger el ELB.  

**3.3 - Seleccionar opciones de seguridad de datos adecuadas**  
- **Servicios de AWS**:  
  - **AWS KMS (Key Management Service)**: Para cifrado de datos.  
  - **Amazon S3 Bucket Policies**: Para controlar el acceso a los buckets.  
- **Ejemplo**:  
  - Usa KMS para cifrar datos en tránsito y en reposo (ej. datos de tarjetas de crédito en RDS).  

---

#### **Dominio 4: Diseñar Arquitecturas Optimizadas en Costos**

**4.1 - Identificar soluciones de almacenamiento rentables**  
- **Servicios de AWS**:  
  - **Amazon S3 Glacier**: Para almacenamiento de backups a largo plazo.  
  - **S3 Lifecycle Policies**: Para mover datos a clases de almacenamiento más económicas.  
- **Ejemplo**:  
  - Usa S3 Glacier para almacenar backups de la base de datos después de 30 días.  

**4.2 - Identificar servicios de cómputo y bases de datos rentables**  
- **Servicios de AWS**:  
  - **Amazon EC2 Spot Instances**: Para cargas de trabajo tolerantes a interrupciones.  
  - **Amazon RDS Reserved Instances**: Para bases de datos con uso predecible.  
- **Ejemplo**:  
  - Usa Spot Instances para tareas de procesamiento por lotes (ej. generación de informes).  

**4.3 - Diseñar arquitecturas de red optimizadas en costos**  
- **Servicios de AWS**:  
  - **Amazon CloudFront**: Para reducir costos de transferencia de datos.  
  - **VPC Endpoints**: Para acceder a servicios de AWS sin salir de la red privada.  
- **Ejemplo**:  
  - Usa CloudFront para reducir la carga en los servidores y minimizar costos de transferencia de datos.  


A colleague tells you about a service that uses machine learning to discover and protect sensitive data stored in S3 buckets. Which AWS service does this?
