A continuación tienes una lista de los comandos de Git más utilizados en un entorno Linux (aunque los mismos comandos aplican también a Windows y macOS). Git se utiliza para el control de versiones y la colaboración en proyectos de software. Estos comandos cubren desde la configuración inicial hasta la gestión de ramas y la publicación de cambios en repositorios remotos:

1. **git config**
    
    - Configura las opciones de Git a nivel global o local.
    - Ejemplos:
        
        ```
        git config --global user.name "TuNombre"
        git config --global user.email "tuemail@example.com"
        ```
        
    - Estos ajustes se guardan en tu archivo `~/.gitconfig`.
2. **git init**
    
    - Inicializa un nuevo repositorio Git en el directorio actual.
    - Crea un subdirectorio oculto llamado `.git` con toda la información necesaria para el seguimiento de versiones.
    - Ejemplo:
        
        ```
        git init
        ```
        
3. **git clone**
    
    - Crea una copia local de un repositorio remoto (por ejemplo, en GitHub o GitLab).
    - Ejemplo:
        
        ```
        git clone https://github.com/usuario/repositorio.git
        ```
        
4. **git status**
    
    - Muestra el estado actual del repositorio: cambios sin confirmar, archivos sin seguimiento, etc.
    - Ejemplo:
        
        ```
        git status
        ```
        
5. **git add**
    
    - Añade cambios al área de “stagging” (prepara los cambios que quieres confirmar).
    - Ejemplos:
        - Agregar un archivo individual:
            
            ```
            git add archivo.txt
            ```
            
        - Agregar todos los archivos modificados en el proyecto:
            
            ```
            git add .
            ```
            
6. **git commit**
    
    - Registra los cambios agregados en el repositorio, asignándoles un mensaje descriptivo.
    - Ejemplo:
        
        ```
        git commit -m "Mensaje describiendo los cambios"
        ```
        
    - Para incluir todos los archivos modificados (saltando la etapa de “add”), se puede usar la opción `-a`:
        
        ```
        git commit -am "Mensaje describiendo los cambios"
        ```
        
7. **git push**
    
    - Envía los cambios confirmados (commits) del repositorio local al repositorio remoto.
    - Ejemplo:
        
        ```
        git push origin main
        ```
        
    - `origin` es el nombre remoto por defecto y `main` o `master` es la rama principal en la mayoría de los proyectos (esto puede variar dependiendo del repositorio).
8. **git pull**
    
    - Actualiza la copia local con los cambios del repositorio remoto. Combina “fetch” (descargar) y “merge” (fusionar).
    - Ejemplo:
        
        ```
        git pull origin main
        ```
        
9. **git branch**
    
    - Muestra las ramas existentes o crea una nueva rama.
    - Ejemplo (listar ramas):
        
        ```
        git branch
        ```
        
    - Ejemplo (crear rama):
        
        ```
        git branch nombre-de-la-rama
        ```
        
10. **git switch** (o **git checkout** para versiones anteriores de Git)
    
    - Cambia a la rama especificada (o crea y cambia, con el flag `-c`).
    - Ejemplos:
        
        ```
        git switch nombre-de-la-rama
        ```
        
        ```
        git switch -c nueva-rama
        ```
        
    - Con versiones anteriores de Git:
        
        ```
        git checkout nombre-de-la-rama
        git checkout -b nueva-rama
        ```
        
11. **git merge**
    
    - Fusiona la rama especificada en la rama actual.
    - Ejemplo:
        
        ```
        git merge nombre-de-la-rama
        ```
        
    - Tras este comando, si hay conflictos, Git te indicará qué archivos requieren resolución manual.
12. **git fetch**
    
    - Descarga todos los objetos y referencias de una rama o repositorio remoto, pero no fusiona automáticamente los cambios.
    - Posteriormente se puede hacer un `git merge` o revisar con `git status` para decidir qué acciones tomar.
13. **git remote**
    
    - Gestiona las URLs remotas asociadas a tu repositorio local.
    - Ejemplos:
        - Ver los repositorios remotos configurados:
            
            ```
            git remote -v
            ```
            
        - Agregar un repositorio remoto:
            
            ```
            git remote add origin https://github.com/usuario/repositorio.git
            ```
            
14. **git log**
    
    - Muestra el historial de confirmaciones (commits) del repositorio.
    - Se puede personalizar con múltiples opciones, por ejemplo:
        
        ```
        git log --oneline --graph --decorate
        ```
        
        que muestra un formato condensado con grafo de ramas.
15. **git stash**
    
    - Guarda temporalmente los cambios no confirmados en “stash” para limpiar el área de trabajo sin hacer un commit.
    - Ejemplos:
        - Guardar cambios:
            
            ```
            git stash
            ```
            
        - Restaurar cambios guardados más recientemente:
            
            ```
            git stash pop
            ```
            
16. **git reset**
    
    - Deshace cambios en la rama local, moviendo el puntero de rama a un commit anterior.
    - Ejemplos:
        - `git reset --soft HEAD~1`: Mueve el puntero un commit atrás pero deja tus archivos en el estado en el que estaban (mantiene los cambios en el área de stage).
        - `git reset --hard HEAD~1`: Mueve el puntero un commit atrás y descarta los cambios (¡irrecuperable!).
17. **git revert**
    
    - Crea un nuevo commit que “revierte” los cambios de un commit anterior sin alterar el historial. Se usa para deshacer cambios ya publicados.
    - Ejemplo:
        
        ```
        git revert <ID_del_commit>
        ```
        
18. **git rebase**
    
    - Reaplica commits de una rama en otra, creando un historial lineal en lugar de un merge. Muy útil para mantener un historial limpio, pero requiere cierta cautela en proyectos colaborativos.
    - Ejemplo:
        
        ```
        git checkout rama-feature
        git rebase main
        ```
        
19. **git tag**
    
    - Crea etiquetas en puntos específicos del historial (por ejemplo, marcar versiones de lanzamiento).
    - Ejemplo:
        
        ```
        git tag -a v1.0 -m "Versión 1.0"
        ```
        
20. **git rm / git mv**
    
    - **git rm**: Elimina archivos del repositorio y del árbol de trabajo (o solo del repositorio con ciertas banderas).
    - **git mv**: Renombra o mueve archivos, facilitando que Git reconozca esos cambios.
    - Ejemplos:
        
        ```
        git rm archivo.txt
        git mv archivo_viejo.txt archivo_nuevo.txt
        ```
        

---

Estos comandos deberían cubrir la mayoría de las operaciones básicas (y algunas más avanzadas) para el uso diario de Git. Recuerda que puedes consultar la documentación detallada de cualquier comando con:

```
git help <comando>
```

o

```
git <comando> --help
```