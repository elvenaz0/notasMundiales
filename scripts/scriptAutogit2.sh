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
