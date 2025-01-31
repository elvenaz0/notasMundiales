Análisis y Solución de Error en SonarQube: CrashLoopBackOff por Plugin Incompatible

En este documento describimos el proceso de análisis y la solución de un problema de arranque en SonarQube desplegado en Kubernetes (AKS). El síntoma principal era que el pod de SonarQube aparecía en estado CrashLoopBackOff y, al revisar los logs, se observaba un error relacionado con incompatibilidad de librerías de Spring Boot ocasionado por el plugin “1C (BSL) Community Plugin”.

1. Contexto del Problema

- SonarQube se encontraba desplegado en AKS y reiniciaba continuamente en modo CrashLoopBackOff.
    
- Al revisar los logs (con “kubectl logs <nombre_pod>”), se evidenció que el servicio inicia (cargando Elasticsearch, plugins, etc.) pero se detiene en la fase de inicialización de uno de los plugins.
    
- El mensaje relevante en los logs es:
    
    Caused by: java.lang.IllegalArgumentException: Class [org.springframework.boot.autoconfigure.SharedMetadataReaderFactoryContextInitializer] is not assignable to factory type [org.springframework.context.ApplicationContextInitializer]
    
    Y se hace referencia a:
    
    BSLLanguageServerRuleDefinition.getActivatedRuleKeys(BSLLanguageServerRuleDefinition.java:109) ... Deploy 1C (BSL) Community Plugin / 1.15.0 / ...
    
    Esto señala que el plugin “1C (BSL) Community Plugin” está utilizando una versión de Spring diferente (o incompatible) con la que usa internamente SonarQube, ocasionando que SonarQube no pueda completar su arranque y termine en CrashLoopBackOff.
    

2. Proceso de Análisis

- Identificar el estado del pod. Observamos que el pod de SonarQube en AKS mostraba el estado CrashLoopBackOff. Al ejecutar “kubectl describe pod <nombre_pod>”, revisamos los eventos que indicaban reinicios constantes.
- Revisar los logs detallados de SonarQube. Con “kubectl logs <nombre_pod>” o “kubectl logs <nombre_pod> --previous”, confirmamos que el contenedor cae durante la fase final de inicialización.
- Analizar el stack trace de Java. Identificamos el BeanCreationException debido a una incompatibilidad en Spring. Se menciona explícitamente la clase BSLLanguageServerRuleDefinition del plugin “1C (BSL)”.
- Hipótesis: conflicto con el plugin 1C (BSL). El error ocurre al cargar este plugin, lo que sugiere que es el responsable de la incompatibilidad. Para confirmar, se recomienda remover temporalmente el plugin y ver si SonarQube arranca correctamente.

3. Solución Paso a Paso

Paso 1: Ubicar los plugins

- Los plugins de SonarQube suelen encontrarse en: /opt/sonarqube/extensions/plugins o un directorio similar.

Paso 2: Remover (o aislar) el plugin 1C (BSL)

- Acceder al contenedor (o volumen) donde se encuentran los plugins.
- Eliminar o mover el archivo “.jar” correspondiente a 1C (BSL) Community Plugin. Por ejemplo: cd /opt/sonarqube/extensions/plugins mv sonar-bsl-plugin-1.15.0.jar /tmp/ El nombre exacto del archivo puede variar según la versión del plugin.

Paso 3: Reiniciar SonarQube

- En Kubernetes, borrar el pod para forzar su recreación: kubectl delete pod sonarqube-5c69946d7-72kst El Deployment o ReplicaSet se encargará de iniciar un nuevo pod.
- Verificar el nuevo pod y sus logs: kubectl get pods kubectl logs <nuevo_nombre_pod>
- Si SonarQube inicia correctamente sin el plugin, se confirma que el plugin era la causa del fallo.

Paso 4: Actualizar o buscar versión compatible del plugin

- Si se requiere el plugin 1C (BSL), es necesario descargar la versión más reciente compatible con la versión actual de SonarQube.
- Instalar el nuevo “.jar” en la carpeta /extensions/plugins.
- Reiniciar nuevamente SonarQube para verificar que la incompatibilidad se haya solucionado.

Paso 5: Confirmar el estado final

- Revisar los logs para asegurarse de que ya no aparezcan errores de incompatibilidad.
- Confirmar que el servidor de SonarQube esté disponible accediendo a su interfaz (normalmente en el puerto 9000).

4. Conclusiones

- El problema surge debido a una colisión de dependencias entre la versión de SonarQube (y sus librerías de Spring Boot internas) y el plugin 1C (BSL) Community.
- Al remover o actualizar ese plugin, SonarQube puede arrancar sin contratiempos.
- Para prevenir estos errores, se recomienda verificar la compatibilidad de cualquier plugin con la versión específica de SonarQube antes de instalarlo.

Si se necesita el plugin 1C (BSL):

- Descargar la última versión que declare soporte para la versión de SonarQube en uso.
- Reinstalarla y revisar los logs para garantizar que no existan conflictos.

Con esto concluimos el análisis y la solución del problema.