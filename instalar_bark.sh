#!/bin/bash
# ====================================
# AUTOINSTALADOR BARK TTS - SUNO AI
# EstacionKusTV/EstacionKusMedia
# ====================================

set -e

echo "╔════════════════════════════════════════════╗"
echo "║    AUTOINSTALADOR BARK TTS - SUNO AI      ║"
echo "║    Text-to-Audio Generativo con IA        ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Detectar sistema operativo
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="MacOS"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    OS="Windows"
else
    OS="Unknown"
fi

echo "✓ Sistema detectado: $OS"
echo ""

# Verificar Python
echo "→ Verificando Python..."
if ! command -v python3 &> /dev/null; then
    echo "✗ Python 3 no está instalado"
    echo "  Por favor instala Python 3.8 o superior"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d " " -f 2)
echo "✓ Python $PYTHON_VERSION detectado"
echo ""

# Verificar pip
echo "→ Verificando pip..."
if ! command -v pip3 &> /dev/null; then
    echo "✗ pip no está instalado"
    echo "  Instalando pip..."
    python3 -m ensurepip --upgrade
fi
echo "✓ pip instalado"
echo ""

# Crear directorio de trabajo
echo "→ Creando directorio de instalación..."
INSTALL_DIR="$HOME/bark-tts"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
echo "✓ Directorio creado: $INSTALL_DIR"
echo ""

# Crear entorno virtual
echo "→ Creando entorno virtual Python..."
python3 -m venv bark-env
source bark-env/bin/activate 2>/dev/null || source bark-env/Scripts/activate 2>/dev/null
echo "✓ Entorno virtual activado"
echo ""

# Actualizar pip
echo "→ Actualizando pip..."
pip install --upgrade pip setuptools wheel
echo ""

# Instalar PyTorch
echo "→ Instalando PyTorch..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
echo "✓ PyTorch instalado"
echo ""

# Instalar Bark
echo "→ Instalando Bark desde repositorio oficial..."
pip install git+https://github.com/suno-ai/bark.git
echo "✓ Bark instalado"
echo ""

# Instalar dependencias adicionales
echo "→ Instalando herramientas adicionales..."
pip install scipy numpy soundfile
echo "✓ Dependencias adicionales instaladas"
echo ""

# Crear script de ejemplo
echo "→ Creando scripts de ejemplo..."
cat > ejemplo_basico.py << 'ENDOFFILE'
#!/usr/bin/env python3
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav

print("Descargando modelos...")
preload_models()
print("Modelos cargados")

texto = "Hola, soy EstacionKusTV. Bienvenidos a nuestro canal."
print("Generando audio...")
audio = generate_audio(texto)

output_file = "salida_basica.wav"
write_wav(output_file, SAMPLE_RATE, audio)
print(f"Audio generado: {output_file}")
ENDOFFILE

chmod +x ejemplo_basico.py
echo "✓ Scripts creados"
echo ""

echo "╔════════════════════════════════════════════╗"
echo "║     ✓ INSTALACIÓN COMPLETADA              ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "→ Ubicación: $INSTALL_DIR"
echo ""
echo "Para comenzar:"
echo "  1. cd $INSTALL_DIR"
echo "  2. source bark-env/bin/activate"
echo "  3. python3 ejemplo_basico.py"
echo ""
echo "¡Listo para producir audio con IA!"
