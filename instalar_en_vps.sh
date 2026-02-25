#!/bin/bash
# Script para instalar en VPS después de clonar el repo

echo "================================================"
echo "  INSTALANDO BARK STUDIO PRO EN VPS"
echo "  EstacionKusTV/EstacionKusMedia"
echo "================================================"
echo ""

# Verificar que estamos en el repo
if [ ! -f "instalar_bark_studio_pro.sh" ]; then
    echo "ERROR: Este script debe ejecutarse dentro del repo clonado"
    echo ""
    echo "Primero ejecuta:"
    echo "  git clone https://github.com/luisitoys12/bark-tts-spots-estacionkus.git"
    echo "  cd bark-tts-spots-estacionkus"
    exit 1
fi

# Dar permisos de ejecución
chmod +x instalar_bark_studio_pro.sh

# Ejecutar instalador
./instalar_bark_studio_pro.sh

echo ""
echo "================================================"
echo "  INSTALACIÓN COMPLETA"
echo "================================================"
echo ""
echo "Para actualizar en el futuro:"
echo "  cd ~/bark-tts-spots-estacionkus"
echo "  git pull"
echo ""
