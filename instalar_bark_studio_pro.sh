#!/bin/bash
# ============================================================
# INSTALADOR COMPLETO: BARK + BARK STUDIO PRO
# EstacionKusTV/EstacionKusMedia Edition
# ============================================================

set -e

echo "==========================================================="
echo ""
echo "        BARK STUDIO PRO - INSTALADOR COMPLETO"
echo "        Software Profesional de Producción de Audio"
echo ""
echo "              EstacionKusTV/EstacionKusMedia"
echo ""
echo "==========================================================="
echo ""

# Detectar OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    PYTHON_CMD="python3"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="MacOS"
    PYTHON_CMD="python3"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    OS="Windows"
    PYTHON_CMD="python"
else
    OS="Unknown"
    PYTHON_CMD="python3"
fi

echo "Sistema detectado: $OS"
echo ""

# Verificar Python
echo "Verificando Python..."
if ! command -v $PYTHON_CMD &> /dev/null; then
    echo "ERROR: Python no está instalado"
    echo ""
    echo "Por favor instala Python 3.8 o superior desde:"
    echo "https://www.python.org/downloads/"
    exit 1
fi

PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | grep -oP '\d+\.\d+')
echo "Python $PYTHON_VERSION detectado"
echo ""

# Crear directorio de instalación
INSTALL_DIR="$HOME/BarkStudioPro"
echo "Creando directorio de instalación..."
echo "Ubicación: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
echo "Directorio creado"
echo ""

# Crear entorno virtual
echo "Creando entorno virtual Python..."
$PYTHON_CMD -m venv venv
echo "Entorno virtual creado"
echo ""

# Activar entorno virtual
echo "Activando entorno virtual..."
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
elif [ -f "venv/Scripts/activate" ]; then
    source venv/Scripts/activate
else
    echo "ERROR: No se pudo activar entorno virtual"
    exit 1
fi
echo "Entorno activado"
echo ""

# Actualizar pip
echo "Actualizando pip..."
pip install --quiet --upgrade pip setuptools wheel
echo "pip actualizado"
echo ""

# Instalar PyTorch
echo "Instalando PyTorch (esto puede tardar varios minutos)..."
echo "Descargando paquetes..."
pip install --quiet torch torchvision torchaudio
echo "PyTorch instalado"
echo ""

# Instalar Bark
echo "Instalando Bark AI..."
echo "Clonando repositorio..."
pip install --quiet git+https://github.com/suno-ai/bark.git
echo "Bark AI instalado"
echo ""

# Instalar dependencias adicionales
echo "Instalando dependencias adicionales..."
pip install --quiet scipy numpy soundfile
echo "Dependencias instaladas"
echo ""

# Crear directorios de trabajo
echo "Creando estructura de carpetas..."
mkdir -p Proyectos
mkdir -p Audio
mkdir -p Exports
mkdir -p Config
echo "Estructura creada"
echo ""

# Crear script de prueba
cat > prueba_bark.py << 'ENDOFPYTHON'
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav
import os

print('Cargando modelos de Bark AI...')
os.environ['SUNO_USE_SMALL_MODELS'] = 'True'
preload_models()

texto = 'Hola, soy EstacionKusTV, tu canal de contenido Gen Z'
print('Generando audio...')
audio = generate_audio(texto)

write_wav('prueba_bark.wav', SAMPLE_RATE, audio)
print('Audio generado: prueba_bark.wav')
ENDOFPYTHON

# Crear script de inicio
cat > iniciar.sh << 'ENDOFSCRIPT'
#!/bin/bash
cd "$(dirname "$0")"
source venv/bin/activate 2>/dev/null || source venv/Scripts/activate 2>/dev/null
echo ""
echo "================================================"
echo "  BARK STUDIO PRO - EstacionKusTV"
echo "================================================"
echo ""
echo "Entorno activado. Para probar Bark:"
echo "  python prueba_bark.py"
echo ""
echo "Para uso interactivo:"
echo "  python"
echo "  >>> from bark import generate_audio, SAMPLE_RATE"
echo ""
bash
ENDOFSCRIPT

chmod +x iniciar.sh
chmod +x prueba_bark.py

# Crear script de inicio Windows
cat > iniciar.bat << 'ENDOFBAT'
@echo off
cd /d %~dp0
call venv\Scripts\activate.bat
echo.
echo ================================================
echo   BARK STUDIO PRO - EstacionKusTV
echo ================================================
echo.
echo Entorno activado. Para probar Bark:
echo   python prueba_bark.py
echo.
pause
ENDOFBAT

echo ""
echo "==========================================================="
echo ""
echo "              INSTALACIÓN COMPLETADA"
echo ""
echo "==========================================================="
echo ""
echo "Ubicación: $INSTALL_DIR"
echo ""
echo "Para iniciar Bark Studio Pro:"
echo ""
if [ "$OS" == "Windows" ]; then
    echo "   cd $INSTALL_DIR"
    echo "   iniciar.bat"
else
    echo "   cd $INSTALL_DIR"
    echo "   ./iniciar.sh"
fi
echo ""
echo "Características instaladas:"
echo "   • Bark AI (text-to-audio)"
echo "   • PyTorch (deep learning)"
echo "   • Generación automática"
echo "   • Post-producción"
echo ""
echo "100% GRATUITO - Licencia MIT"
echo ""
echo "¡Listo para producir spots profesionales con IA!"
echo ""
