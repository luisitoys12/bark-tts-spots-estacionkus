# 🔧 Guía de Solución de Problemas

## 🔴 Problema: Letras Rojas en pip Durante Instalación

### ¿Es Normal?

**SÍ**, las letras rojas de pip son **NORMALES** y no son errores críticos. Son **warnings** (advertencias) que pip muestra pero que no detienen la instalación.

### Tipos de Warnings Comunes

```
WARNING: Running pip as the 'root' user...
WARNING: Ignoring invalid distribution...
Defaulting to user installation...
```

**Estos son seguros de ignorar.**

### Solución

El instalador actualizado **ya filtra** estos warnings automáticamente.

```bash
cd ~/bark-tts-spots-estacionkus
git pull  # Actualizar repo
chmod +x instalar_bark_studio_pro.sh
./instalar_bark_studio_pro.sh
```

---

## 🔴 Problema: Script Se Cierra Inmediatamente

### Causa

El script tenía `set -e` que lo hacía abortar ante cualquier warning.

### Solución

**YA CORREGIDO** en la última versión. Actualiza:

```bash
cd ~/bark-tts-spots-estacionkus
git pull
./instalar_bark_studio_pro.sh
```

---

## 🔴 Problema: ERROR - Python no encontrado

### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
```

### Linux (CentOS/RHEL)

```bash
sudo yum install python3 python3-pip
```

### macOS

```bash
brew install python3
```

Verificar:
```bash
python3 --version
```

---

## 🔴 Problema: ERROR - No se puede crear entorno virtual

### Linux

```bash
sudo apt install python3-venv
# o
sudo yum install python3-virtualenv
```

### Alternativa Manual

```bash
pip3 install virtualenv
python3 -m virtualenv venv
```

---

## 🔴 Problema: PyTorch No Se Instala

### Síntomas

```
ERROR: Could not find a version that satisfies the requirement torch
```

### Solución 1: Instalar Manualmente

```bash
cd ~/BarkStudioPro
source venv/bin/activate

# CPU version (más compatible)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
```

### Solución 2: Python Antiguo

Si tienes Python < 3.8:

```bash
python3 --version  # Verificar

# Actualizar Python
sudo apt install python3.10  # Ubuntu
# o descargar desde python.org
```

---

## 🔴 Problema: Bark No Se Instala

### Síntomas

```
ERROR: Command errored out with exit status 1
```

### Solución: Instalar Git

```bash
# Linux
sudo apt install git

# macOS
brew install git

# Verificar
git --version
```

Luego reintentar:

```bash
cd ~/BarkStudioPro
source venv/bin/activate
pip install git+https://github.com/suno-ai/bark.git
```

---

## 🔴 Problema: Modelos No Se Descargan

### Síntomas

```
Downloading models...
[Se queda atascado]
```

### Solución: Descargar Manualmente

```bash
cd ~/BarkStudioPro
source venv/bin/activate

python3 << EOF
from bark import preload_models
import os

os.environ['SUNO_USE_SMALL_MODELS'] = 'True'
print('Descargando modelos...')
preload_models()
print('Modelos descargados')
EOF
```

### Verificar Espacio en Disco

```bash
df -h ~
# Necesitas al menos 5 GB libres
```

---

## 🔴 Problema: Audio Muy Lento (CPU)

### Es Normal

En CPU, la generación tarda **30-120 segundos** por spot.

### Optimizar

```python
import os
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
os.environ["SUNO_OFFLOAD_CPU"] = "True"
```

**Ya incluido** en los scripts por defecto.

---

## 🔴 Problema: Audio Suena Mal / Robotic

### Soluciones

1. **Regenerar** (Bark es aleatorio):
```bash
python generador_spots_avanzado.py
# Genera el mismo texto 2-3 veces y elige el mejor
```

2. **Usar preset de voz específico**:
```python
audio = generate_audio(texto, history_prompt="v2/es_speaker_1")
```

3. **Post-producir en Audacity**:
- Reducción de Ruido
- Normalizar
- Compresor
- Ecualizador

---

## 🔴 Problema: ERROR - CUDA out of memory

### Solución: Forzar CPU

```python
import os
os.environ["SUNO_OFFLOAD_CPU"] = "True"
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
```

O en bash antes de ejecutar:

```bash
export SUNO_OFFLOAD_CPU="True"
export SUNO_USE_SMALL_MODELS="True"
python prueba_bark.py
```

---

## 🔴 Problema: Permisos Denegados

### Síntomas

```
bash: ./instalar_bark_studio_pro.sh: Permission denied
```

### Solución

```bash
chmod +x instalar_bark_studio_pro.sh
chmod +x instalar_en_vps.sh
./instalar_bark_studio_pro.sh
```

---

## 🔴 Problema: ModuleNotFoundError: No module named 'bark'

### Causa

Entorno virtual no activado.

### Solución

```bash
cd ~/BarkStudioPro
source venv/bin/activate

# Ahora sí:
python prueba_bark.py
```

O usa el script de inicio:

```bash
cd ~/BarkStudioPro
./iniciar.sh
```

---

## ✅ Verificar Instalación Correcta

### Script de Verificación

```bash
cd ~/BarkStudioPro
source venv/bin/activate

python << EOF
print("Verificando instalación...\n")

try:
    import torch
    print("✓ PyTorch instalado")
except:
    print("❌ PyTorch NO instalado")

try:
    import bark
    print("✓ Bark instalado")
except:
    print("❌ Bark NO instalado")

try:
    import scipy
    print("✓ SciPy instalado")
except:
    print("❌ SciPy NO instalado")

try:
    import numpy
    print("✓ NumPy instalado")
except:
    print("❌ NumPy NO instalado")

print("\nSi todos tienen ✓, la instalación es correcta.")
EOF
```

---

## 🎛️ Comandos Útiles

### Ver Logs de Instalación

```bash
./instalar_bark_studio_pro.sh 2>&1 | tee instalacion.log
cat instalacion.log
```

### Limpiar y Reinstalar

```bash
rm -rf ~/BarkStudioPro
cd ~/bark-tts-spots-estacionkus
./instalar_bark_studio_pro.sh
```

### Actualizar Desde GitHub

```bash
cd ~/bark-tts-spots-estacionkus
git pull
./instalar_bark_studio_pro.sh
```

---

## 📞 Soporte

Si ninguna solución funciona:

1. **Issues GitHub**: [Crear issue](https://github.com/luisitoys12/bark-tts-spots-estacionkus/issues)
2. **Email**: in3707989@gmail.com
3. **Discord Suno**: [suno.ai/discord](https://suno.ai/discord)

### Incluir en tu reporte:

```bash
# Sistema
uname -a

# Python
python3 --version

# Espacio en disco
df -h ~

# Log de error completo
./instalar_bark_studio_pro.sh 2>&1 | tee error.log
cat error.log
```

---

**EstacionKusTV/EstacionKusMedia**  
*Powered by Bark AI (Suno)*
