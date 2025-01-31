# Subir una Carpeta de Notas de Obsidian a GitHub

Este documento describe cómo subir una carpeta de notas de la app **Obsidian** a un repositorio de GitHub llamado `notasMundiales`.

---

## **Paso 1: Configuración inicial**

### 1.1 Verifica que tienes Git instalado
Asegúrate de que `git` esté instalado y funcionando:
```bash
git --version
```
Si no lo tienes, instala Git desde [https://git-scm.com/downloads](https://git-scm.com/downloads).

### 1.2 Inicia sesión en GitHub CLI (opcional)
Si tienes instalada la CLI de GitHub, inicia sesión para simplificar las interacciones:
```bash
gh auth login
```

### 1.3 Crea un repositorio en GitHub
- Ve a GitHub y crea un repositorio nuevo llamado `notasMundiales` manualmente.
- O usa la CLI para crearlo directamente:
```bash
gh repo create notasMundiales --public --description "Notas de la app Obsidian"
```

---

## **Paso 2: Navega a tu carpeta de notas de Obsidian**
1. Abre la terminal y navega a la carpeta donde están tus notas:
   ```bash
   cd "C:\ruta\a\tu\carpeta\de\notas"
   ```

2. Verifica que estás en la carpeta correcta:
   ```bash
   dir
   ```
   Esto debería mostrar los archivos y carpetas de tus notas.

---

## **Paso 3: Inicializa y configura el repositorio con GitHub CLI**
1. Inicializa el repositorio local:
   ```bash
   git init
   ```

2. Conecta el repositorio local al remoto con GitHub CLI:
   ```bash
   gh repo set-default notasMundiales
   ```

3. (Opcional) Crea un archivo `.gitignore` para excluir archivos no deseados, como configuraciones específicas de Obsidian:
   - Crea un archivo llamado `.gitignore` en la raíz de la carpeta.
   - Añade las siguientes líneas:
     ```
     .obsidian/
     .DS_Store
     Thumbs.db
     ```
   - Guarda el archivo.

---

## **Paso 4: Sube los archivos al repositorio con GitHub CLI**
1. Añade todos los archivos al repositorio:
   ```bash
   git add .
   ```

2. Realiza un commit inicial:
   ```bash
   git commit -m "Subiendo notas de Obsidian"
   ```

3. Sube los archivos al repositorio remoto:
   ```bash
   gh repo sync
   ```

---

## **Paso 5: Verifica en GitHub**
1. Ve al repositorio `notasMundiales` en tu cuenta de GitHub.
2. Asegúrate de que los archivos de tus notas estén subidos correctamente.

---

## **Futuras actualizaciones**
Cuando hagas cambios en tus notas y quieras actualizarlas en GitHub, usa los siguientes comandos:

1. Añade los cambios:
   ```bash
   git add .
   ```

2. Realiza un nuevo commit:
   ```bash
   git commit -m "Actualizando notas"
   ```

3. Sube los cambios al repositorio remoto:
   ```bash
   gh repo sync
   ```

---

