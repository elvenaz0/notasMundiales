
Pasos para desplegar servicios relacionados a los principios del titulo

---

### **Servicios a Desplegar**
1. **AWS Lambda**: Para procesamiento de datos en tiempo real.
2. **Amazon DynamoDB**: Para almacenar datos procesados.
3. **Amazon S3**: Para almacenar datos brutos.
4. **Amazon SQS**: Para desacoplar el procesamiento de datos.
5. **Amazon API Gateway**: Para recibir datos de entrada.

---

### **Pasos para Desplegar en la Consola de AWS**

#### **1. Configurar AWS Lambda**
6. **Acceder a la Consola de AWS**:
   - Inicia sesión en [AWS Management Console](https://aws.amazon.com/console/).
   - Busca **Lambda** en la barra de búsqueda y selecciona el servicio.

7. **Crear una Función Lambda**:
   - Haz clic en **"Create function"**.
   - Selecciona **"Author from scratch"**.
   - Asigna un nombre (ej: `ProcesarDatos`).
   - Elige un runtime (ej: Python 3.9).
   - En **Permissions**, crea un nuevo rol con permisos básicos para Lambda.

8. **Configurar el Código**:
   - En la pestaña **Code**, pega el siguiente código de ejemplo (procesa datos y los guarda en DynamoDB):
     ```python
     import json
     import boto3

     dynamodb = boto3.resource('dynamodb')
     table = dynamodb.Table('DatosProcesados')

     def lambda_handler(event, context):
         for record in event['Records']:
             data = json.loads(record['body'])
             table.put_item(Item=data)
         return {
             'statusCode': 200,
             'body': json.dumps('Datos procesados correctamente')
         }
     ```
   - Haz clic en **Deploy** para guardar.

9. **Configurar el Trigger**:
   - En la pestaña **Triggers**, haz clic en **"Add trigger"**.
   - Selecciona **SQS** como origen y elige la cola que crearás en el siguiente paso.

---

#### **2. Configurar Amazon SQS**
10. **Acceder a SQS**:
   - Busca **SQS** en la consola y selecciona el servicio.

11. **Crear una Cola**:
   - Haz clic en **"Create queue"**.
   - Elige **Standard Queue**.
   - Asigna un nombre (ej: `DatosEntrada`).
   - Configura los parámetros según tus necesidades (ej: retención de mensajes por 7 días).

12. **Conectar SQS a Lambda**:
   - En la cola creada, ve a la pestaña **Lambda triggers**.
   - Selecciona la función Lambda que creaste anteriormente (`ProcesarDatos`).

---

#### **3. Configurar Amazon DynamoDB**
13. **Acceder a DynamoDB**:
   - Busca **DynamoDB** en la consola y selecciona el servicio.

14. **Crear una Tabla**:
   - Haz clic en **"Create table"**.
   - Asigna un nombre (ej: `DatosProcesados`).
   - Define una clave primaria (ej: `id` como clave de partición).
   - Configura la capacidad de lectura/escritura en **On-Demand** para optimizar costos.

15. **Conectar DynamoDB a Lambda**:
   - Asegúrate de que el rol de Lambda tenga permisos para DynamoDB (puedes agregar la política `AmazonDynamoDBFullAccess` en IAM).

---

#### **4. Configurar Amazon S3**
16. **Acceder a S3**:
   - Busca **S3** en la consola y selecciona el servicio.

17. **Crear un Bucket**:
   - Haz clic en **"Create bucket"**.
   - Asigna un nombre único (ej: `datos-brutos-empresa`).
   - Configura las opciones de acceso (recomendado: bloquear acceso público).
   - Habilita **Versioning** y **Server-side encryption** para mayor seguridad.

18. **Configurar Eventos de S3**:
   - Ve a la pestaña **Properties** del bucket.
   - En **Event notifications**, crea un evento para enviar notificaciones a SQS cuando se suban nuevos archivos.

---

#### **5. Configurar Amazon API Gateway**
19. **Acceder a API Gateway**:
   - Busca **API Gateway** en la consola y selecciona el servicio.

20. **Crear una API**:
   - Haz clic en **"Create API"**.
   - Selecciona **HTTP API**.
   - Asigna un nombre (ej: `EntradaDatos`).

21. **Configurar Rutas y Métodos**:
   - Crea una ruta (ej: `/datos`) y un método POST.
   - Integra el método POST con la cola SQS (`DatosEntrada`).

22. **Desplegar la API**:
   - Ve a la pestaña **Deploy** y crea un stage (ej: `prod`).
   - Obtén la URL de la API para usarla en tu aplicación.

---

### **Resumen de Pasos**
| **Servicio**       | **Acción**                                                                 |
|---------------------|---------------------------------------------------------------------------|
| **Lambda**          | Crear función, agregar código, conectar a SQS.                            |
| **SQS**             | Crear cola estándar, conectar a Lambda.                                   |
| **DynamoDB**        | Crear tabla con clave primaria, otorgar permisos a Lambda.                |
| **S3**              | Crear bucket, habilitar versioning y cifrado, configurar eventos a SQS.   |
| **API Gateway**     | Crear API HTTP, configurar ruta y método POST, integrar con SQS.          |

---
