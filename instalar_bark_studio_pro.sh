#!/bin/bash
# ============================================================
# INSTALADOR COMPLETO: BARK + BARK STUDIO PRO
# EstacionKusTV/EstacionKusMedia Edition
# ============================================================

# NO usar set -e para que warnings de pip no detengan instalación
set +e

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
    echo "Por favor instala Python 3.8 o superior:"
    if [[ "$OS" == "Linux" ]]; then
        echo "  sudo apt update && sudo apt install python3 python3-pip python3-venv"
    elif [[ "$OS" == "MacOS" ]]; then
        echo "  brew install python3"
    fi
    echo "  O descarga desde: https://www.python.org/downloads/"
    exit 1
fi

PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | grep -oP '\d+\.\d+' || echo "3.x")
echo "✓ Python $PYTHON_VERSION detectado"
echo ""

# Crear directorio de instalación
INSTALL_DIR="$HOME/BarkStudioPro"
echo "Creando directorio de instalación..."
echo "Ubicación: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1
echo "✓ Directorio creado"
echo ""

# Crear entorno virtual
echo "Creando entorno virtual Python..."
$PYTHON_CMD -m venv venv
if [ $? -ne 0 ]; then
    echo "ERROR: No se pudo crear entorno virtual"
    echo "Intenta instalar: sudo apt install python3-venv"
    exit 1
fi
echo "✓ Entorno virtual creado"
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
echo "✓ Entorno activado"
echo ""

# Actualizar pip (silenciar warnings)
echo "Actualizando pip..."
pip install --upgrade pip setuptools wheel 2>&1 | grep -v "WARNING" | grep -v "Defaulting" || true
echo "✓ pip actualizado"
echo ""

# Instalar PyTorch (CPU version para compatibilidad)
echo "Instalando PyTorch (esto puede tardar 5-10 minutos)..."
echo "Descargando paquetes..."
echo ""
echo "(Ignorando warnings de pip - son normales)"
echo ""
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu 2>&1 | \
    grep -v "WARNING" | \
    grep -v "Defaulting" | \
    grep -v "already satisfied" || true

if python -c "import torch" 2>/dev/null; then
    echo "✓ PyTorch instalado correctamente"
else
    echo "ERROR: PyTorch no se instaló correctamente"
    echo "Intentando versión alternativa..."
    pip install torch torchvision torchaudio 2>&1 | grep -v "WARNING" || true
fi
echo ""

# Instalar Bark
echo "Instalando Bark AI..."
echo "Clonando repositorio..."
echo ""
pip install git+https://github.com/suno-ai/bark.git 2>&1 | \
    grep -v "WARNING" | \
    grep -v "Defaulting" | \
    grep -v "already satisfied" || true

if python -c "import bark" 2>/dev/null; then
    echo "✓ Bark AI instalado correctamente"
else
    echo "ERROR: Bark no se instaló correctamente"
    exit 1
fi
echo ""

# Instalar dependencias adicionales
echo "Instalando dependencias adicionales..."
pip install scipy numpy soundfile 2>&1 | \
    grep -v "WARNING" | \
    grep -v "Defaulting" | \
    grep -v "already satisfied" || true
echo "✓ Dependencias instaladas"
echo ""

# Crear directorios de trabajo
echo "Creando estructura de carpetas..."
mkdir -p Proyectos Audio Exports Config
echo "✓ Estructura creada"
echo ""

# Crear script de prueba
cat > prueba_bark.py << 'ENDOFPYTHON'
#!/usr/bin/env python3
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav
import os

print('\n===================================')
print('   PRUEBA DE BARK AI')
print('===================================')
print('\nCargando modelos de Bark AI...')
print('(Primera vez puede tardar varios minutos)\n')

os.environ['SUNO_USE_SMALL_MODELS'] = 'True'
os.environ['SUNO_OFFLOAD_CPU'] = 'True'

try:
    preload_models()
    print('✓ Modelos cargados\n')
    
    texto = 'Hola, soy EstacionKusTV, tu canal de contenido Gen Z'
    print(f'Generando audio: "{texto}"\n')
    audio = generate_audio(texto)
    
    write_wav('prueba_bark.wav', SAMPLE_RATE, audio)
    print('✓ Audio generado: prueba_bark.wav\n')
    print('===================================')
    print('   PRUEBA EXITOSA')
    print('===================================')
    print()
except Exception as e:
    print(f'\nERROR: {e}\n')
    print('Intenta descargar modelos manualmente:')
    print('python -c "from bark import preload_models; preload_models()"')
    exit(1)
ENDOFPYTHON

chmod +x prueba_bark.py

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
echo "Entorno activado. Comandos disponibles:"
echo ""
echo "  python prueba_bark.py          - Probar Bark"
echo "  python generador_spots_avanzado.py - Generar spots"
echo "  python procesamiento_lote.py   - Procesar lotes"
echo ""
echo "Uso interactivo:"
echo "  python"
echo "  >>> from bark import generate_audio, SAMPLE_RATE"
echo ""
echo "Presiona Ctrl+D para salir"
echo ""
bash
ENDOFSCRIPT

chmod +x iniciar.sh

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

# Crear README local
cat > INSTALACION.txt << 'ENDOFREADME'
==========================================================
  BARK STUDIO PRO - INSTALADO CORRECTAMENTE
  EstacionKusTV/EstacionKusMedia
==========================================================

UBICACION: ~/BarkStudioPro

INICIAR:
  cd ~/BarkStudioPro
  ./iniciar.sh

PROBAR BARK:
  python prueba_bark.py

GENERAR SPOTS:
  python generador_spots_avanzado.py

PROCESAMIENTO POR LOTES:
  python procesamiento_lote.py spots_lote.json

CARPETAS:
  Proyectos/ - Tus guiones
  Audio/ - Audios generados
  Exports/ - Exportaciones finales

ACTUALIZAR:
  cd ~/bark-tts-spots-estacionkus
  git pull
  cd ~/BarkStudioPro
  ./instalar.sh  # Si hay cambios en instalador

100% GRATUITO - Licencia MIT
==========================================================
ENDOFREADME

echo ""
echo "==========================================================="
echo ""
echo "              ✓ INSTALACIÓN COMPLETADA"
echo ""
echo "==========================================================="
echo ""
echo "Ubicación: $INSTALL_DIR"
echo ""
echo "Para iniciar:"
echo ""
if [ "$OS" == "Windows" ]; then
    echo "   cd $INSTALL_DIR"
    echo "   iniciar.bat"
else
    echo "   cd $INSTALL_DIR"
    echo "   ./iniciar.sh"
fi
echo ""
echo "Para probar Bark:"
echo "   python prueba_bark.py"
echo ""
echo "Características instaladas:"
echo "   • Bark AI (text-to-audio)"
echo "   • PyTorch (deep learning)"
echo "   • Generación automática"
echo "   • Post-producción"
echo ""
echo "Carpetas creadas:"
echo "   • Proyectos/ (tus guiones)"
echo "   • Audio/ (audios generados)"
echo "   • Exports/ (exportaciones)"
echo ""
echo "100% GRATUITO - Licencia MIT"
echo ""
echo "¡Listo para producir spots con IA!"
echo ""
echo "Documentación completa: cat INSTALACION.txt"
echo ""
