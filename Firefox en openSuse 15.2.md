
---

# Instalación de Firefox en openSUSE Leap 15.2 (AWS)

### 1. **Identificar versión del SO**
```bash
cat /etc/os-release | grep VERSION_ID
# Salida esperada: VERSION_ID="15.2"
```

---

### 2. **Agregar repositorios oficiales**
```bash
# Repositorio OSS (software principal)
sudo zypper ar -f http://download.opensuse.org/distribution/leap/15.2/repo/oss/ repo-oss

# Repositorio Non-OSS (software no open-source)
sudo zypper ar -f http://download.opensuse.org/distribution/leap/15.2/repo/non-oss/ repo-non-oss

# Repositorio de actualizaciones de seguridad
sudo zypper ar -f http://download.opensuse.org/update/leap/15.2/oss/ repo-update
```

---

### 3. **Actualizar repositorios**
```bash
sudo zypper --gpg-auto-import-keys refresh
```

---

### 4. **Instalar Firefox**
```bash
sudo zypper install MozillaFirefox
```

---

### 5. **Resolver dependencias faltantes (opcional)**
Si aparece el error `libgtk-3.so.0`:
```bash
sudo zypper install gtk3-devel libgtk-3-0
```

---

### 6. **Verificar instalación**
```bash
rpm -q MozillaFirefox  # Debe mostrar la versión instalada
firefox --version      # Ejemplo: "Mozilla Firefox 102.15.0esr"
```

---

## Opción Alternativa: Instalación Manual
### Si los repositorios fallan:
```bash
# Descargar Firefox desde Mozilla
wget "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=es-ES" -O firefox.tar.bz2

# Descomprimir en /opt
sudo tar -xjf firefox.tar.bz2 -C /opt/

# Crear enlace simbólico
sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox

# Instalar dependencias críticas
sudo zypper install libgtk-3-0 dbus-1-glib libXtst6 libX11-xcb1
```

---

## Comandos de Diagnóstico
| Comando                      | Propósito                                  |
|------------------------------|--------------------------------------------|
| `sudo zypper lr`             | Listar repositorios configurados           |
| `zypper search MozillaFirefox` | Buscar el paquete en repositorios         |
| `rpm -ql MozillaFirefox`     | Ver archivos instalados por el paquete     |

---

## Notas Técnicas
1. **Versiones Legacy**:  
   Leap 15.2 alcanzó su fin de vida en enero de 2022. Se recomienda actualizar a una versión soportada (ej: 15.5+).

2. **AWS Considerations**:  
   - Asegurar que el **Security Group** permita tráfico HTTP/HTTPS saliente.  
   - Si usas **Session Manager**, verifica que la instancia tenga acceso a internet.

3. **Errores Comunes**:  
   - `Failed to retrieve metadata`: Verifica las URLs de los repositorios.  
   - `Package not found`: Ejecuta `sudo zypper refresh --force`.

```bash
# Forzar actualización de repositorios (si falla)
sudo zypper refresh --force
```

