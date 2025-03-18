

A continuación, encontrarás una lista de algunos de los comandos más básicos y útiles de Linux, junto con una breve descripción de su uso. Estos comandos pueden variar ligeramente según la distribución de Linux que estés utilizando, pero en general funcionan de forma muy parecida en la mayoría de sistemas basados en UNIX.

1. **pwd** (Print Working Directory)
    
    - Muestra la ruta completa del directorio en el que te encuentras actualmente.
    - Ejemplo:
        
        ```
        pwd
        ```
        
2. **ls** (List)
    
    - Lista los archivos y carpetas del directorio actual (o el que indiques).
    - Algunas opciones comunes:
        - `ls -l`: Muestra la lista en formato largo (permisos, propietario, tamaño, fecha, etc.).
        - `ls -a`: Muestra también los archivos ocultos (los que empiezan por “.”).
    - Ejemplo:
        
        ```
        ls -l
        ```
        
3. **cd** (Change Directory)
    
    - Cambia al directorio especificado.
    - Ejemplos:
        - `cd /home/usuario/Documentos`
        - `cd ..` (Sube un nivel en el sistema de archivos).
4. **mkdir** (Make Directory)
    
    - Crea un nuevo directorio con el nombre que especifiques.
    - Ejemplo:
        
        ```
        mkdir mi_carpeta
        ```
        
5. **rmdir** (Remove Directory)
    
    - Elimina un directorio vacío. Si el directorio no está vacío, este comando no funcionará. Para eliminar directorios con contenido, se suele usar `rm -r`.
    - Ejemplo:
        
        ```
        rmdir mi_carpeta
        ```
        
6. **rm** (Remove)
    
    - Elimina archivos o directorios. Úsalo con cuidado porque no hay Papelera de Reciclaje donde vayan los elementos borrados.
    - Para eliminar un archivo:
        
        ```
        rm archivo.txt
        ```
        
    - Para eliminar un directorio con todo su contenido (opción recursiva):
        
        ```
        rm -r carpeta
        ```
        
    - **¡Precaución!:** `rm -r` elimina todo de forma permanente en la carpeta especificada.
7. **cp** (Copy)
    
    - Copia archivos y carpetas.
    - Ejemplos:
        - Copiar un archivo:
            
            ```
            cp archivo_origen.txt archivo_destino.txt
            ```
            
        - Copiar un directorio de forma recursiva:
            
            ```
            cp -r carpeta_origen carpeta_destino
            ```
            
8. **mv** (Move)
    
    - Mueve o renombra archivos y directorios.
    - Ejemplos:
        - Mover un archivo a otra carpeta:
            
            ```
            mv archivo.txt /ruta/destino/
            ```
            
        - Renombrar un archivo:
            
            ```
            mv archivo.txt archivo_renombrado.txt
            ```
            
9. **cat**
    
    - Muestra el contenido de un archivo en la terminal.
    - Ejemplo:
        
        ```
        cat archivo.txt
        ```
        
10. **less**
    
    - Permite ver el contenido de un archivo de forma paginada, de manera que puedas desplazarte con las flechas.
    - Ejemplo:
        
        ```
        less archivo.txt
        ```
        
11. **touch**
    
    - Crea un archivo vacío o actualiza la fecha de modificación si el archivo ya existe.
    - Ejemplo:
        
        ```
        touch archivo_nuevo.txt
        ```
        
12. **sudo** (SuperUser DO)
    
    - Permite ejecutar comandos con privilegios de superusuario (administrador).
    - Ejemplo:
        
        ```
        sudo apt-get update
        ```
        
13. **chmod** (Change Mode)
    
    - Cambia los permisos de un archivo o carpeta.
    - Ejemplo (dar permisos de lectura, escritura y ejecución al propietario):
        
        ```
        chmod 700 archivo.sh
        ```
        
14. **chown** (Change Owner)
    
    - Cambia el propietario y/o el grupo asociado a un archivo o carpeta.
    - Ejemplo:
        
        ```
        sudo chown nuevo_propietario:nuevo_grupo archivo.txt
        ```
        
15. **grep**
    
    - Busca patrones de texto dentro de un archivo o en la salida de otros comandos.
    - Ejemplo (busca la palabra “Error” en un archivo de log):
        
        ```
        grep "Error" log_sistema.txt
        ```
        
16. **head** y **tail**
    
    - **head** muestra las primeras líneas de un archivo.
    - **tail** muestra las últimas líneas de un archivo.
    - Ejemplos:
        
        ```
        head -n 10 archivo.txt   # Muestra las primeras 10 líneas
        tail -n 10 archivo.txt   # Muestra las últimas 10 líneas
        ```
        
17. **top**
    
    - Muestra en tiempo real los procesos que se están ejecutando en el sistema, incluyendo consumo de CPU, memoria, etc.
18. **ps**
    
    - Muestra una lista de procesos en ejecución en ese momento. Se suele combinar con `grep` para buscar procesos específicos:
        
        ```
        ps aux | grep nombre_proceso
        ```
        
19. **kill**
    
    - Detiene un proceso por su número de PID (Process ID). Primero usas `ps` o `top` para obtener el PID.
    - Ejemplo:
        
        ```
        kill 1234
        ```
        
20. **sudo apt-get update / sudo apt-get upgrade** (Debian, Ubuntu y derivados)
    
    - Actualiza la lista de paquetes disponibles e instala las actualizaciones pendientes. Estos comandos son específicos de sistemas basados en Debian/Ubuntu.

---

Estos son solo algunos de los comandos básicos que te ayudarán a empezar en Linux. Con el tiempo, irás descubriendo muchísimos más que pueden facilitar tareas de administración y automatización. Puedes consultar manuales más detallados con:

```
man <nombre_del_comando>
```

Por ejemplo, `man ls` te mostrará el manual completo del comando `ls`. ¡Explora y práctica para familiarizarte más con el entorno de Linux!