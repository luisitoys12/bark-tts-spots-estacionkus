# ====================================
# AUTOINSTALADOR BARK TTS - WINDOWS
# EstacionKusTV/EstacionKusMedia
# ====================================

Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    AUTOINSTALADOR BARK TTS - SUNO AI      ║" -ForegroundColor Cyan
Write-Host "║    Text-to-Audio Generativo con IA        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar Python
Write-Host "→ Verificando Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version
    Write-Host "✓ $pythonVersion detectado" -ForegroundColor Green
} catch {
    Write-Host "✗ Python no encontrado" -ForegroundColor Red
    Write-Host "  Descarga Python desde: https://www.python.org/downloads/" -ForegroundColor Red
    exit 1
}

# Crear directorio
$installDir = "$env:USERPROFILE\\bark-tts"
Write-Host "→ Creando directorio: $installDir" -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Set-Location $installDir

# Crear entorno virtual
Write-Host "→ Creando entorno virtual..." -ForegroundColor Yellow
python -m venv bark-env
.\\bark-env\\Scripts\\Activate.ps1

# Actualizar pip
Write-Host "→ Actualizando pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip setuptools wheel

# Instalar PyTorch
Write-Host "→ Instalando PyTorch..." -ForegroundColor Yellow
pip install torch torchvision torchaudio

# Instalar Bark
Write-Host "→ Instalando Bark..." -ForegroundColor Yellow
pip install git+https://github.com/suno-ai/bark.git

# Instalar dependencias
Write-Host "→ Instalando dependencias..." -ForegroundColor Yellow
pip install scipy numpy soundfile

# Crear script ejemplo
$ejemploScript = @"
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav

print("Cargando modelos...")
preload_models()
texto = "Hola desde EstacionKusTV"
audio = generate_audio(texto)
write_wav("salida.wav", SAMPLE_RATE, audio)
print("Audio generado: salida.wav")
"@

Set-Content -Path "ejemplo_basico.py" -Value $ejemploScript

Write-Host ""
Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║     ✓ INSTALACIÓN COMPLETADA              ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Para usar:" -ForegroundColor Cyan
Write-Host "  1. .\\bark-env\\Scripts\\Activate.ps1" -ForegroundColor White
Write-Host "  2. python ejemplo_basico.py" -ForegroundColor White
