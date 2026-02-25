# ============================================================
# INSTALADOR BARK STUDIO PRO - WINDOWS
# EstacionKusTV/EstacionKusMedia Edition
# ============================================================

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  BARK STUDIO PRO - INSTALADOR WINDOWS" -ForegroundColor Cyan
Write-Host "  Software Profesional de Audio con IA" -ForegroundColor Cyan
Write-Host "  EstacionKusTV/EstacionKusMedia" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Python
Write-Host "Verificando Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Python detectado: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Python no encontrado" -ForegroundColor Red
    Write-Host "Descarga Python desde: https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host "Asegurate de marcar 'Add Python to PATH' durante instalacion" -ForegroundColor Yellow
    pause
    exit 1
}
Write-Host ""

# Crear directorio
$installDir = "$env:USERPROFILE\\BarkStudioPro"
Write-Host "Creando directorio: $installDir" -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Set-Location $installDir
Write-Host "Directorio creado correctamente" -ForegroundColor Green
Write-Host ""

# Crear entorno virtual
Write-Host "Creando entorno virtual Python..." -ForegroundColor Yellow
python -m venv venv
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudo crear entorno virtual" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "Entorno virtual creado" -ForegroundColor Green
Write-Host ""

# Activar entorno
Write-Host "Activando entorno virtual..." -ForegroundColor Yellow
& ".\\venv\\Scripts\\Activate.ps1"
Write-Host "Entorno activado" -ForegroundColor Green
Write-Host ""

# Actualizar pip
Write-Host "Actualizando pip..." -ForegroundColor Yellow
python -m pip install --quiet --upgrade pip setuptools wheel
Write-Host "pip actualizado" -ForegroundColor Green
Write-Host ""

# Instalar PyTorch
Write-Host "Instalando PyTorch (puede tardar varios minutos)..." -ForegroundColor Yellow
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Fallo instalacion de PyTorch" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "PyTorch instalado" -ForegroundColor Green
Write-Host ""

# Instalar Bark
Write-Host "Instalando Bark AI..." -ForegroundColor Yellow
pip install git+https://github.com/suno-ai/bark.git
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Fallo instalacion de Bark" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "Bark AI instalado" -ForegroundColor Green
Write-Host ""

# Instalar dependencias
Write-Host "Instalando dependencias adicionales..." -ForegroundColor Yellow
pip install scipy numpy soundfile
Write-Host "Dependencias instaladas" -ForegroundColor Green
Write-Host ""

# Crear estructura
Write-Host "Creando estructura de carpetas..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "Proyectos" | Out-Null
New-Item -ItemType Directory -Force -Path "Audio" | Out-Null
New-Item -ItemType Directory -Force -Path "Exports" | Out-Null
Write-Host "Estructura creada" -ForegroundColor Green
Write-Host ""

# Crear script de prueba
Write-Host "Creando script de prueba..." -ForegroundColor Yellow
$scriptPrueba = @"
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
"@

Set-Content -Path "prueba_bark.py" -Value $scriptPrueba -Encoding UTF8

# Crear script de inicio
$scriptInicio = @"
@echo off
cd /d %~dp0
call venv\\Scripts\\activate.bat
cls
echo ===============================================
echo   BARK STUDIO PRO - EstacionKusTV
echo ===============================================
echo.
echo Entorno activado correctamente
echo.
echo Para probar Bark:
echo   python prueba_bark.py
echo.
echo Para usar interactivo:
echo   python
echo   from bark import generate_audio, SAMPLE_RATE
echo.
pause
"@

Set-Content -Path "iniciar.bat" -Value $scriptInicio -Encoding ASCII

Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host "  INSTALACION COMPLETADA EXITOSAMENTE" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Ubicacion: $installDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para iniciar:" -ForegroundColor Yellow
Write-Host "  1. Abre: $installDir" -ForegroundColor White
Write-Host "  2. Ejecuta: iniciar.bat" -ForegroundColor White
Write-Host ""
Write-Host "Para probar Bark:" -ForegroundColor Yellow
Write-Host "  python prueba_bark.py" -ForegroundColor White
Write-Host ""
Write-Host "Carpetas creadas:" -ForegroundColor Cyan
Write-Host "  - Proyectos/ (tus guiones)" -ForegroundColor White
Write-Host "  - Audio/ (audios generados)" -ForegroundColor White
Write-Host "  - Exports/ (exportaciones finales)" -ForegroundColor White
Write-Host ""
Write-Host "100% GRATIS - Licencia MIT" -ForegroundColor Green
Write-Host ""
pause
