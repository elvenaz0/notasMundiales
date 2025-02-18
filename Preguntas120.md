### **1. Introducción a AWS y Conceptos Básicos de la Nube**

1. **¿Qué es la computación en la nube?**  
   Respuesta: Es la entrega de recursos informáticos bajo demanda a través de Internet con un modelo de pago por uso.

2. **¿Cuáles son los tres modelos de servicio en la nube?**  
   Respuesta: IaaS (Infraestructura como Servicio), PaaS (Plataforma como Servicio) y SaaS (Software como Servicio).

3. **¿Qué es IaaS?**  
   Respuesta: Proporciona infraestructura informática como servidores virtuales, almacenamiento y redes.

4. **¿Qué es PaaS?**  
   Respuesta: Ofrece una plataforma para desarrollar, ejecutar y gestionar aplicaciones sin preocuparse por la infraestructura.

5. **¿Qué es SaaS?**  
   Respuesta: Software al que se accede a través de Internet, sin necesidad de instalación local.

6. **¿Cuáles son los modelos de despliegue en la nube?**  
   Respuesta: Nube pública, nube privada y nube híbrida.

7. **¿Qué es una nube pública?**  
   Respuesta: Servicios en la nube ofrecidos por proveedores como AWS, accesibles a través de Internet.

8. **¿Qué es una nube privada?**  
   Respuesta: Infraestructura en la nube utilizada exclusivamente por una organización.

9. **¿Qué es una nube híbrida?**  
   Respuesta: Combinación de nube pública y privada, con recursos compartidos entre ambas.

10. **¿Cuál es una ventaja clave de la nube?**  
    Respuesta: Elasticidad: capacidad de escalar recursos hacia arriba o hacia abajo según la demanda.

---

### **2. Arquitectura de AWS y Servicios Principales**

1. **¿Qué es una Región en AWS?**  
    Respuesta: Una ubicación geográfica donde AWS tiene múltiples centros de datos (Availability Zones).

2. **¿Qué es una Zona de Disponibilidad (AZ)?**  
    Respuesta: Un centro de datos o grupo de centros de datos dentro de una Región, diseñado para ser aislado de fallos.

3. **¿Qué es un Edge Location?**  
    Respuesta: Ubicaciones de AWS utilizadas por CloudFront para almacenar en caché contenido y reducir la latencia.

4. **¿Qué es EC2?**  
    Respuesta: Un servicio que proporciona servidores virtuales escalables en la nube.

5. **¿Qué es S3?**  
    Respuesta: Un servicio de almacenamiento de objetos escalable y duradero.

6. **¿Qué es RDS?**  
    Respuesta: Un servicio de bases de datos relacionales gestionado.

7. **¿Qué es Lambda?**  
    Respuesta: Un servicio de computación sin servidor que ejecuta código en respuesta a eventos.

8. **¿Qué es IAM?**  
    Respuesta: Un servicio que gestiona el acceso seguro a los recursos de AWS.

9. **¿Qué es VPC?**  
    Respuesta: Un servicio que permite crear una red virtual privada en AWS.

10. **¿Qué es alta disponibilidad?**  
    Respuesta: Diseño de sistemas para garantizar que estén operativos la mayor parte del tiempo.

11. **¿Qué es escalabilidad?**  
    Respuesta: Capacidad de un sistema para manejar un crecimiento en la carga de trabajo.

12. **¿Qué es tolerancia a fallos?**  
    Respuesta: Capacidad de un sistema para continuar operando incluso si algún componente falla.

13. **¿Qué es Auto Scaling?**  
    Respuesta: Un servicio que ajusta automáticamente la capacidad de los recursos según la demanda.

14. **¿Qué es Elastic Load Balancing (ELB)?**  
    Respuesta: Un servicio que distribuye el tráfico entrante entre múltiples instancias.

15. **¿Qué es CloudFront?**  
    Respuesta: Un servicio de red de entrega de contenido (CDN) que acelera la entrega de contenido.

16. **¿Qué es Route 53?**  
    Respuesta: Un servicio de DNS gestionado que enruta el tráfico a recursos de AWS.

17. **¿Qué es SNS?**  
    Respuesta: Un servicio de notificaciones que envía mensajes a suscriptores.

18. **¿Qué es SQS?**  
    Respuesta: Un servicio de colas de mensajes que desacopla componentes de aplicaciones.

19. **¿Qué es CloudFormation?**  
    Respuesta: Un servicio que permite crear y gestionar infraestructura como código.

20. **¿Qué es EBS?**  
    Respuesta: Un servicio de almacenamiento en bloque para instancias EC2.

---

### **3. Seguridad y Cumplimiento en AWS**

21. **¿Qué es el modelo de responsabilidad compartida?**  
    Respuesta: AWS es responsable de la seguridad "de" la nube, y el cliente es responsable de la seguridad "en" la nube.

22. **¿Qué es IAM?**  
    Respuesta: Identity and Access Management, un servicio que gestiona usuarios, grupos, roles y permisos.

23. **¿Qué es una política de IAM?**  
    Respuesta: Un documento que define permisos para usuarios, grupos o roles.

24. **¿Qué es KMS?**  
    Respuesta: Key Management Service, un servicio para crear y gestionar claves de cifrado.

25. **¿Qué es CloudTrail?**  
    Respuesta: Un servicio que registra las llamadas API en una cuenta de AWS.

26. **¿Qué es CloudWatch?**  
    Respuesta: Un servicio de monitoreo y gestión de recursos y aplicaciones.

27. **¿Qué es AWS Config?**  
    Respuesta: Un servicio que evalúa y audita la configuración de los recursos de AWS.

28. **¿Qué es un grupo de seguridad en AWS?**  
    Respuesta: Un firewall virtual que controla el tráfico entrante y saliente de las instancias EC2.

29. **¿Qué es un NACL (Network Access Control List)?**  
    Respuesta: Una capa de seguridad opcional para una VPC que controla el tráfico entrante y saliente.

30. **¿Qué es GDPR?**  
    Respuesta: Reglamento General de Protección de Datos, una normativa de privacidad de la UE.

31. **¿Qué es HIPAA?**  
    Respuesta: Ley de Portabilidad y Responsabilidad de Seguros de Salud, que regula la protección de datos de salud.

32. **¿Qué es una AMI?**  
    Respuesta: Amazon Machine Image, una plantilla que contiene la configuración de una instancia EC2.

33. **¿Qué es un bucket en S3?**  
    Respuesta: Un contenedor para almacenar objetos en S3.

34. **¿Qué es el cifrado en tránsito?**  
    Respuesta: Protección de datos mientras se transmiten a través de redes.

35. **¿Qué es el cifrado en reposo?**  
    Respuesta: Protección de datos almacenados en discos o bases de datos.

36. **¿Qué es AWS Shield?**  
    Respuesta: Un servicio de protección contra ataques DDoS.

37. **¿Qué es AWS WAF?**  
    Respuesta: Web Application Firewall, un servicio que protege aplicaciones web de exploits comunes.

38. **¿Qué es AWS Artifact?**  
    Respuesta: Un portal para acceder a informes de cumplimiento y acuerdos de AWS.

39. **¿Qué es AWS Organizations?**  
    Respuesta: Un servicio para gestionar múltiples cuentas de AWS.

40. **¿Qué es AWS Control Tower?**  
    Respuesta: Un servicio que facilita la configuración y gobernanza de múltiples cuentas de AWS.

---

### **4. Facturación y Gestión de Costos**

41. **¿Qué es el modelo de precios de AWS?**  
    Respuesta: Pago por uso, sin costos iniciales y con capacidad de escalar según la demanda.

42. **¿Qué es AWS Free Tier?**  
    Respuesta: Un nivel gratuito que permite a los nuevos clientes usar ciertos servicios de AWS sin costo.

43. **¿Qué es AWS Cost Explorer?**  
    Respuesta: Una herramienta para visualizar y analizar los costos de AWS.

44. **¿Qué es AWS Budgets?**  
    Respuesta: Un servicio que permite establecer alertas de costos y uso.

45. **¿Qué es Trusted Advisor?**  
    Respuesta: Una herramienta que proporciona recomendaciones para optimizar costos, seguridad y rendimiento.

46. **¿Qué es Reserved Instances?**  
    Respuesta: Una opción de compra que ofrece descuentos a cambio de un compromiso de uso a largo plazo.

47. **¿Qué es Spot Instances?**  
    Respuesta: Instancias EC2 que se pueden adquirir a un costo reducido, pero con la posibilidad de ser interrumpidas.

48. **¿Qué es Savings Plans?**  
    Respuesta: Un modelo de ahorro que ofrece descuentos a cambio de un compromiso de uso constante.

49. **¿Qué es AWS Pricing Calculator?**  
    Respuesta: Una herramienta para estimar el costo de los servicios de AWS.

50. **¿Qué es un SLA (Acuerdo de Nivel de Servicio)?**  
    Respuesta: Un compromiso de AWS sobre la disponibilidad y rendimiento de sus servicios.

---

### **5. Soporte y SLA**

51. **¿Cuáles son los planes de soporte de AWS?**  
    Respuesta: Basic, Developer, Business y Enterprise.

52. **¿Qué incluye el plan de soporte Basic?**  
    Respuesta: Acceso a documentación, foros y alertas de estado de servicio.

53. **¿Qué incluye el plan de soporte Enterprise?**  
    Respuesta: Soporte técnico 24/7, un Technical Account Manager (TAM) y consultoría arquitectónica.

54. **¿Qué es AWS Trusted Advisor?**  
    Respuesta: Una herramienta que proporciona recomendaciones para optimizar costos, seguridad y rendimiento.

55. **¿Qué es AWS Health Dashboard?**  
    Respuesta: Un panel que muestra el estado de los servicios de AWS y notificaciones personalizadas.

---

### **6. Preguntas Adicionales para Práctica**

56. **¿Qué es AWS Snowball?**  
    Respuesta: Un servicio para transferir grandes cantidades de datos a AWS mediante dispositivos físicos.

57. **¿Qué es AWS Glue?**  
    Respuesta: Un servicio de integración de datos que prepara y carga datos para análisis.

58. **¿Qué es AWS Athena?**  
    Respuesta: Un servicio que permite consultar datos en S3 usando SQL.

59. **¿Qué es AWS Redshift?**  
    Respuesta: Un servicio de almacenamiento de datos en la nube para análisis a gran escala.

60. **¿Qué es AWS DynamoDB?**  
    Respuesta: Una base de datos NoSQL gestionada y altamente escalable.

61. **¿Qué es AWS Elastic Beanstalk?**  
    Respuesta: Un servicio para implementar y gestionar aplicaciones sin preocuparse por la infraestructura.

62. **¿Qué es AWS Fargate?**  
    Respuesta: Un motor de computación sin servidor para contenedores.

63. **¿Qué es AWS ECS?**  
    Respuesta: Elastic Container Service, un servicio para ejecutar contenedores Docker.

64. **¿Qué es AWS EKS?**  
    Respuesta: Elastic Kubernetes Service, un servicio para ejecutar Kubernetes en AWS.

65. **¿Qué es AWS Step Functions?**  
    Respuesta: Un servicio para orquestar workflows de aplicaciones distribuidas.

66. **¿Qué es AWS X-Ray?**  
    Respuesta: Un servicio para analizar y depurar aplicaciones distribuidas.

67. **¿Qué es AWS CodeCommit?**  
    Respuesta: Un servicio de control de versiones basado en Git.

68. **¿Qué es AWS CodeBuild?**  
    Respuesta: Un servicio para compilar y probar código.

69. **¿Qué es AWS CodeDeploy?**  
    Respuesta: Un servicio para automatizar implementaciones de aplicaciones.

70. **¿Qué es AWS CodePipeline?**  
    Respuesta: Un servicio de integración y entrega continua (CI/CD).

71. **¿Qué es AWS OpsWorks?**  
    Respuesta: Un servicio de gestión de configuraciones basado en Chef.

72. **¿Qué es AWS Systems Manager?**  
    Respuesta: Un servicio para gestionar y automatizar tareas operativas.

73. **¿Qué es AWS Backup?**  
    Respuesta: Un servicio para automatizar y gestionar copias de seguridad.

74. **¿Qué es AWS Glacier?**  
    Respuesta: Un servicio de almacenamiento de archivos para copias de seguridad a largo plazo.

75. **¿Qué es AWS Direct Connect?**  
    Respuesta: Un servicio para establecer una conexión de red privada entre AWS y un centro de datos local.

76. **¿Qué es AWS Global Accelerator?**  
    Respuesta: Un servicio que mejora la disponibilidad y rendimiento de aplicaciones globales.

77. **¿Qué es AWS Transit Gateway?**  
    Respuesta: Un servicio para conectar múltiples VPCs y redes locales.

78. **¿Qué es AWS AppSync?**  
    Respuesta: Un servicio para crear APIs GraphQL gestionadas.

79. **¿Qué es AWS Amplify?**  
    Respuesta: Una plataforma para desarrollar aplicaciones web y móviles escalables.

80. **¿Qué es AWS Cognito?**  
    Respuesta: Un servicio para gestionar autenticación y autorización de usuarios.

81. **¿Qué es AWS Secrets Manager?**  
    Respuesta: Un servicio para gestionar secretos como contraseñas y claves de API.

82. **¿Qué es AWS Macie?**  
    Respuesta: Un servicio para descubrir y proteger datos confidenciales en S3.

83. **¿Qué es AWS Inspector?**  
    Respuesta: Un servicio para evaluar la seguridad y cumplimiento de aplicaciones.

84. **¿Qué es AWS GuardDuty?**  
    Respuesta: Un servicio de detección de amenazas en tiempo real.

85. **¿Qué es AWS Single Sign-On (SSO)?**  
    Respuesta: Un servicio para gestionar el acceso a múltiples cuentas y aplicaciones de AWS.

86. **¿Qué es AWS DataSync?**  
    Respuesta: Un servicio para transferir datos entre almacenamiento local y AWS.

87. **¿Qué es AWS Transfer Family?**  
    Respuesta: Un servicio para transferir archivos a S3 usando protocolos como SFTP.

88. **¿Qué es AWS Elemental MediaConvert?**  
    Respuesta: Un servicio para convertir archivos de video a diferentes formatos.

89. **¿Qué es AWS Elemental MediaLive?**  
    Respuesta: Un servicio para transmitir video en vivo.

90. **¿Qué es AWS Elemental MediaPackage?**  
     Respuesta: Un servicio para preparar y proteger video para su distribución.

91. **¿Qué es AWS Elemental MediaStore?**  
     Respuesta: Un servicio de almacenamiento optimizado para video.

92. **¿Qué es AWS Elemental MediaTailor?**  
     Respuesta: Un servicio para insertar anuncios en transmisiones de video.

93. **¿Qué es AWS IoT Core?**  
     Respuesta: Un servicio para conectar dispositivos IoT a la nube.

94. **¿Qué es AWS Greengrass?**  
     Respuesta: Un servicio para ejecutar computación local en dispositivos IoT.

95. **¿Qué es AWS RoboMaker?**  
     Respuesta: Un servicio para desarrollar, probar y desplegar aplicaciones de robótica.

96. **¿Qué es AWS DeepRacer?**  
     Respuesta: Un coche autónomo en miniatura para aprender sobre machine learning.

97. **¿Qué es AWS SageMaker?**  
     Respuesta: Un servicio para construir, entrenar e implementar modelos de machine learning.

98. **¿Qué es AWS Comprehend?**  
     Respuesta: Un servicio de procesamiento de lenguaje natural (NLP).

99. **¿Qué es AWS Rekognition?**  
     Respuesta: Un servicio de análisis de imágenes y videos.

100. **¿Qué es AWS Polly?**  
     Respuesta: Un servicio para convertir texto en voz.

101. **¿Qué es AWS Lex?**  
     Respuesta: Un servicio para construir chatbots y asistentes virtuales.

102. **¿Qué es AWS Translate?**  
     Respuesta: Un servicio de traducción automática de texto.

103. **¿Qué es AWS Transcribe?**  
     Respuesta: Un servicio para convertir voz en texto.

104. **¿Qué es AWS Textract?**  
     Respuesta: Un servicio para extraer texto y datos de documentos.

105. **¿Qué es AWS Personalize?**  
     Respuesta: Un servicio para crear recomendaciones personalizadas.

106. **¿Qué es AWS Forecast?**  
     Respuesta: Un servicio para predecir tendencias y comportamientos futuros.

107. **¿Qué es AWS Fraud Detector?**  
     Respuesta: Un servicio para detectar fraudes en transacciones.

108. **¿Qué es AWS Ground Station?**  
     Respuesta: Un servicio para controlar satélites y procesar datos espaciales.

109. **¿Qué es AWS Outposts?**  
     Respuesta: Un servicio para ejecutar infraestructura de AWS en instalaciones locales.

110. **¿Qué es AWS Wavelength?**  
     Respuesta: Un servicio para implementar aplicaciones de baja latencia en redes 5G.

---
