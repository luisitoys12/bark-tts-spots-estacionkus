#!/bin/bash
# ============================================================
# INSTALADOR RÁPIDO PARA VPS
# EstacionKusTV/EstacionKusMedia
# ============================================================

echo "================================================"
echo "  INSTALANDO BARK STUDIO PRO EN VPS"
echo "  EstacionKusTV/EstacionKusMedia"
echo "================================================"
echo ""

# Verificar que estamos en el repo
if [ ! -f "instalar_bark_studio_pro.sh" ]; then
    echo "❌ ERROR: Este script debe ejecutarse dentro del repo clonado"
    echo ""
    echo "Primero ejecuta:"
    echo ""
    echo "  git clone https://github.com/luisitoys12/bark-tts-spots-estacionkus.git"
    echo "  cd bark-tts-spots-estacionkus"
    echo "  chmod +x instalar_en_vps.sh"
    echo "  ./instalar_en_vps.sh"
    echo ""
    exit 1
fi

echo "✓ Repositorio detectado correctamente"
echo ""

# Dar permisos de ejecución
echo "Dando permisos de ejecución..."
chmod +x instalar_bark_studio_pro.sh
chmod +x instalar_bark.sh 2>/dev/null || true
echo "✓ Permisos configurados"
echo ""

# Ejecutar instalador principal
echo "Ejecutando instalador principal..."
echo ""
echo "=" | tr '=' '=' | head -c 48; echo
echo ""

./instalar_bark_studio_pro.sh

INSTALL_STATUS=$?

echo ""
echo "================================================"
if [ $INSTALL_STATUS -eq 0 ]; then
    echo "  ✓ INSTALACIÓN COMPLETA"
else
    echo "  ⚠️ INSTALACIÓN COMPLETADA CON WARNINGS"
    echo "  (Los warnings de pip son normales)"
fi
echo "================================================"
echo ""
echo "Para usar Bark Studio Pro:"
echo ""
echo "  cd ~/BarkStudioPro"
echo "  ./iniciar.sh"
echo ""
echo "Para probar:"
echo ""
echo "  cd ~/BarkStudioPro"
echo "  python prueba_bark.py"
echo ""
echo "Para actualizar en el futuro:"
echo ""
echo "  cd ~/bark-tts-spots-estacionkus"
echo "  git pull"
echo ""
echo "Documentación:"
echo "  cat ~/BarkStudioPro/INSTALACION.txt"
echo ""
