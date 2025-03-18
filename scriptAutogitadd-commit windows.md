A continuación, te muestro un ejemplo de **archivo por lotes (.bat)** para Windows que hace exactamente lo mismo: agregar todos los archivos al índice de Git y hacer un commit con mensaje que incluya la fecha (día-mes-año) obtenida del sistema Windows. No requiere instalar o usar QBasic; solo utiliza las herramientas por defecto de Windows (cmd.exe) y, por supuesto, Git instalado.

Guarda este contenido en un archivo con extensión `.bat` (por ejemplo, `git_commit_fecha.bat`) y ejecútalo en la consola de Windows (cmd):

```
@echo off
rem =====================================
rem git_commit_fecha.bat
rem =====================================
rem Obtiene la fecha actual en el formato local de Windows.
rem Por ejemplo, en una configuración regional en español podría ser:
rem "mié 18/02/2025" o "mier 18/02/2025"
rem =====================================

rem 1) Capturamos el resultado de "date /T" en dos partes:
rem   - El día de la semana (p.e. "mié")
rem   - El resto (p.e. "18/02/2025")
FOR /F "tokens=1,2" %%i IN ('date /T') DO (
    SET dayOfWeek=%%i
    SET theDate=%%j
)

rem 2) Desglosamos "theDate" (p.e. "18/02/2025") en día, mes y año.
rem   Ajusta delimitadores y tokens si tu configuración regional es distinta.
FOR /F "tokens=1,2,3 delims=/" %%a IN ("%theDate%") DO (
    SET dd=%%a
    SET mm=%%b
    SET yyyy=%%c
)

rem 3) Ejecutamos los comandos de Git:
git add .
git commit -m "%dd%-%mm%-%yyyy%"
```

### Notas importantes

4. **Formato de fecha**: El comando `date /T` devuelve distintos formatos según la configuración regional de tu Windows. Si, por ejemplo, en tu caso aparece algo como `Wed 02/18/2025` (formato anglosajón), tendrás que ajustar los **tokens** (posiciones) y/o los **delimitadores** (`delims`) en el segundo bloque `FOR /F`.
    
5. **Git instalado**: Asegúrate de que Git esté instalado y accesible desde la variable de entorno `PATH`. Para verificarlo, ejecuta `git --version` en la misma consola antes de correr el script.
    
6. **Rutas y permisos**: Si tu repositorio Git se encuentra en una carpeta diferente, muévete primero a la carpeta del repositorio (usando `cd ruta\del\repositorio`) antes de ejecutar el script o, alternativamente, coloca este `.bat` dentro del propio repositorio.