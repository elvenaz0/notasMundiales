
A continuación tienes un ejemplo sencillo en QBasic (archivos .bas) que ejecuta los comandos **git add** y **git commit** usando la fecha del sistema con formato día-mes-año. Ten en cuenta que la salida exacta de `DATE$` puede variar según la configuración regional de tu sistema; es posible que debas ajustar la forma en que cortas las subcadenas si obtienes resultados diferentes.

```basic
' === guarda este código en un archivo con extensión .bas, por ejemplo: git_commit_date.bas ===

CLS

' Declaramos variables para manipular la fecha
DIM fecha AS STRING
DIM dia   AS STRING
DIM mes   AS STRING
DIM anio  AS STRING

' QBasic obtiene la fecha completa a través de DATE$ en el formato predeterminado.
' Por ejemplo, "02-18-2025" o "18-02-2025" dependiendo de la configuración regional.
' Ajusta estos valores de inicio y longitud si tu sistema usa otro orden o separador.

dia  = LEFT$(DATE$, 2)      ' Toma los primeros 2 caracteres -> dd
mes  = MID$(DATE$, 4, 2)    ' Toma 2 caracteres a partir de la posición 4 -> mm
anio = RIGHT$(DATE$, 4)     ' Toma los últimos 4 caracteres -> yyyy

' Construimos la cadena final (formato: dd-mm-yyyy).
fecha = dia + "-" + mes + "-" + anio

' Ejecutamos los comandos de Git mediante SHELL.
' Ten en cuenta que QBasic cerrará la consola tras ejecutar la SHELL,
' por lo que tal vez quieras usar QB64 u otra variante para ver resultados.
SHELL "git add ."
SHELL "git commit -m """ + fecha + """"

END
```

**Cómo usarlo**:

1. Asegúrate de tener instalado QBasic (o QB64, u otro intérprete/compilador BASIC compatible con el comando `SHELL`).
2. Guarda este archivo como `git_commit_date.bas`.
3. Abre QBasic (o tu compilador BASIC preferido) y ejecuta el programa.
4. El script añadirá todos los cambios al índice (`git add .`) y luego hará un commit con el mensaje que incluye el día, mes y año del sistema.