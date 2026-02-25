# 🎙️ Bark Studio Pro - EstacionKus

**Sistema Completo de Producción de Spots Publicitarios con IA**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Bark AI](https://img.shields.io/badge/Powered%20by-Bark%20AI-purple)](https://github.com/suno-ai/bark)

---

## 📦 ¿Qué es esto?

Software profesional **100% GRATIS** para generar spots publicitarios, jingles y narraciones usando **Bark AI** de Suno. 

**Características:**
- ✅ Instalación automática (1 comando)
- ✅ Editor de guiones con formato rápido
- ✅ 100+ voces en múltiples idiomas
- ✅ Generación automática de audio
- ✅ Post-producción integrada
- ✅ Procesamiento por lotes
- ✅ Sistema de invitaciones
- ✅ **Totalmente GRATIS** (MIT License)

---

## 🚀 Instalación Rápida

### Windows
```powershell
# 1. Descarga el repositorio
git clone https://github.com/luisitoys12/bark-tts-spots-estacionkus.git
cd bark-tts-spots-estacionkus

# 2. Permitir ejecución de scripts
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# 3. Ejecutar instalador
.\instalar_bark.ps1
```

### Linux/macOS/VPS
```bash
# 1. Descarga el repositorio
git clone https://github.com/luisitoys12/bark-tts-spots-estacionkus.git
cd bark-tts-spots-estacionkus

# 2. Ejecutar instalador
chmod +x instalar_bark_studio_pro.sh
./instalar_bark_studio_pro.sh
```

**Tiempo de instalación:** 5-10 minutos (descarga automática de modelos)

---

## 🎯 Uso Básico

### Opción 1: Python Directo

```python
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav

# Cargar modelos
preload_models()

# Tu guión
texto = """
[WOMAN] Bienvenidos a EstacionKusTV. [laughs]
El canal que entiende la cultura Gen Z.
Síguenos en todas las plataformas.
"""

# Generar con voz específica
audio = generate_audio(texto, history_prompt="v2/es_speaker_1")

# Guardar
write_wav("mi_spot.wav", SAMPLE_RATE, audio)
```

### Opción 2: Script Interactivo

```bash
cd ~/BarkStudioPro
source venv/bin/activate  # Linux/macOS
# o
venv\Scripts\activate   # Windows

python generador_spots_avanzado.py
```

---

## 🎨 Técnicas de Producción

### Marcadores Especiales

| Marcador | Efecto |
|----------|--------|
| `[laughs]` | Risas naturales |
| `[sighs]` | Suspiros |
| `[gasps]` | Jadeo/sorpresa |
| `[music]` | Música de fondo |
| `♪ texto ♪` | Cantar/jingle |
| `MAYÚSCULAS` | Énfasis |
| `...` | Pausa |
| `[MAN]` / `[WOMAN]` | Control género |

### Ejemplo de Spot Promocional

```python
texto = """
¡Atención! [gasps]
EstacionKusTV presenta la MEGA venta del año.
Descuentos de hasta 50% — sí, CINCUENTA por ciento. [laughs]
¡No lo pienses más!
"""
```

### Ejemplo de Jingle

```python
texto = """
♪ EstacionKus, la radio que te entiende ♪
♪ Noticias frescas y buen ambiente ♪
"""
```

---

## 🎚️ Post-Producción en Audacity

El software genera automáticamente instrucciones para Audacity:

1. **Reducción de Ruido** (20-30%, -10 dB)
2. **Normalizar** (-3.0 dB)
3. **Compresor** (Ratio 3:1, Threshold -20 dB)
4. **Ecualizador** (High-pass 80 Hz, Boost 2-5 kHz)
5. **Limitador** (-0.5 dB)
6. **Exportar** WAV 48000 Hz, -14 LUFS

**Resultado:** Audio broadcast-ready profesional

---

## 💼 Procesamiento por Lotes

Crea `spots_lote.json`:

```json
{
  "spots": [
    {
      "nombre": "promo_matutino",
      "texto": "Buenos días EstacionKusTV...",
      "voz": "v2/es_speaker_1"
    },
    {
      "nombre": "jingle_corto",
      "texto": "♪ EstacionKus ♪",
      "voz": null
    }
  ]
}
```

Ejecuta:
```bash
python procesamiento_lote.py
```

Todos los spots se generan automáticamente.

---

## 📧 Sistema de Invitaciones

```python
from sistema_invitaciones import SistemaInvitaciones

sistema = SistemaInvitaciones()

# Generar códigos
codigos = sistema.generar_multiples(5, "colaborador@email.com")

# Configurar SMTP
config_smtp = {
    'smtp_server': 'smtp.gmail.com',
    'smtp_port': 587,
    'smtp_user': 'tu_email@gmail.com',
    'smtp_password': 'tu_app_password',
    'from_email': 'tu_email@gmail.com',
    'from_name': 'EstacionKusTV'
}

# Enviar email
sistema.enviar_email('destino@email.com', codigos, config_smtp)
```

---

## 🔧 Configuración Avanzada

### Solo CPU (sin GPU)
```python
import os
os.environ["SUNO_OFFLOAD_CPU"] = "True"
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
```

### Con GPU NVIDIA
```python
os.environ["SUNO_OFFLOAD_CPU"] = "False"
```

---

## 🐛 Solución de Problemas

### Audio suena de baja calidad

- Regenera el mismo texto (Bark es aleatorio)
- Usa preset de voz específico
- Aplica pipeline de post-producción completo

### Generación muy lenta

Normal en CPU: 30-120 segundos por spot.

Optimizar:
```python
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
```

---

## 📊 Requisitos del Sistema

| Componente | Mínimo | Recomendado |
|------------|--------|-------------|
| **CPU** | x86_64 | 4+ cores |
| **RAM** | 4 GB | 8 GB |
| **GPU** | No req. | NVIDIA 4+ GB |
| **Storage** | 5 GB | 10 GB |

---

## 💰 Licencia

**100% GRATIS** - Licencia MIT

- ✅ Uso comercial permitido
- ✅ Sin limitaciones
- ✅ Sin suscripciones
- ✅ Sin API keys

---

## 🙌 Créditos

**Desarrollado para:** EstacionKusTV/EstacionKusMedia  
**Powered by:** [Bark AI](https://github.com/suno-ai/bark) (Suno)  
**Versión:** 1.0  
**Fecha:** Febrero 2026

---

## 🔗 Enlaces

- [Documentación Bark](https://github.com/suno-ai/bark)
- [Voice Presets](https://suno-ai.notion.site/8b8e8749ed514b0cbf3f699013548683)
- [Discord Suno](https://suno.ai/discord)

---

## 📞 Soporte

- **Issues:** [GitHub Issues](https://github.com/luisitoys12/bark-tts-spots-estacionkus/issues)
- **Discord:** Comunidad Suno AI
- **Email:** in3707989@gmail.com

---

**¡Listo para producir spots profesionales con IA!** 🎙️✨
