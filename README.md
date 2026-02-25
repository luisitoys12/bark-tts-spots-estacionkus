# 🎙️ Bark TTS - Generador de Spots Publicitarios

**Sistema completo de producción de audio con IA para EstacionKusTV/EstacionKusMedia**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Powered by Bark](https://img.shields.io/badge/Powered%20by-Bark%20AI-green.svg)](https://github.com/suno-ai/bark)

---

## 💡 Qué es este proyecto

Sistema automatizado para generar **spots publicitarios, jingles y contenido de audio** usando [Bark](https://github.com/suno-ai/bark), el modelo text-to-audio generativo de Suno AI.

### ✨ Características

- 🎙️ **Generación de voz multilingue** (13 idiomas incluyendo español)
- 🎵 **Jingles y música** cantada con IA
- 😂 **Efectos vocales** (risas, suspiros, jadeos)
- 🚀 **Autoinstalador** para Linux, macOS y Windows
- 📊 **Procesamiento por lotes** de múltiples spots
- 🎯 **100+ presets de voz** profesionales
- 🛠️ **Pipeline de post-producción** documentado

---

## 🚀 Instalación Rápida

### Linux / macOS

```bash
# Clonar repositorio
git clone https://github.com/luisitoys12/bark-tts-spots-estacionkus.git
cd bark-tts-spots-estacionkus

# Ejecutar instalador
chmod +x instalar_bark.sh
./instalar_bark.sh
```

### Windows PowerShell

```powershell
# Clonar repositorio
git clone https://github.com/luisitoys12/bark-tts-spots-estacionkus.git
cd bark-tts-spots-estacionkus

# Permitir ejecución de scripts
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Ejecutar instalador
.\instalar_bark.ps1
```

### Requisitos

- **Python 3.8+**
- **8 GB RAM mínimo** (16 GB recomendado)
- **5 GB espacio libre** para modelos
- **GPU NVIDIA opcional** (4+ GB VRAM para aceleración)

---

## 🎬 Uso

### Generador Interactivo

```bash
# Activar entorno virtual
source ~/bark-tts/bark-env/bin/activate  # Linux/macOS
# o
.\bark-tts\bark-env\Scripts\activate     # Windows

# Ejecutar generador avanzado
python3 generador_spots_avanzado.py
```

### Ejemplo Básico en Python

```python
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav

# Cargar modelos
preload_models()

# Generar audio
texto = "¡Hola! Soy EstacionKusTV. [laughs] Tu canal de noticias Gen Z."
audio = generate_audio(texto, history_prompt="v2/es_speaker_1")

# Guardar
write_wav("mi_spot.wav", SAMPLE_RATE, audio)
```

### Procesamiento por Lotes

```bash
# Editar spots_lote.json con tus spots
python3 procesamiento_lote.py
```

**Formato JSON:**

```json
{
  "spots": [
    {
      "nombre": "promo_matutino",
      "texto": "¡Buenos días! Sintoniza EstacionKusTV cada mañana.",
      "voz": "v2/es_speaker_1"
    }
  ]
}
```

---

## 🎨 Técnicas de Producción

### Marcadores de Control

| Marcador | Efecto | Ejemplo |
|----------|--------|----------|
| `[laughs]` | Risas | `¡Increíble! [laughs]` |
| `[sighs]` | Suspiros | `Qué día... [sighs]` |
| `[music]` | Música de fondo | `[music] Bienvenidos` |
| `[gasps]` | Jadeo/sorpresa | `¡No puede ser! [gasps]` |
| `MAYÚS` | Énfasis | `Esto es INCREÍBLE` |
| `...` | Pausa/hesitación | `Escucha... esto es importante` |
| `♪ texto ♪` | Cantar/jingle | `♪ EstacionKus, tu voz ♪` |
| `[MAN]`/`[WOMAN]` | Sesgar género | `[WOMAN] Noticias hoy` |

### Catálogo de Voces

| ID | Preset | Descripción | Uso Recomendado |
|----|--------|--------------|------------------|
| `es_1` | `v2/es_speaker_0` | Español neutro | Noticias/Informativo |
| `es_2` | `v2/es_speaker_1` | Español narrador | Documentales/Spots |
| `en_3` | `v2/en_speaker_6` | Masculino energético | Promocionales |
| `en_4` | `v2/en_speaker_9` | Femenino profesional | Institucional |

🔗 [Ver catálogo completo de voces](https://suno-ai.notion.site/8b8e8749ed514b0cbf3f699013548683)

---

## 🎵 Post-Producción

### Pipeline Profesional

1. **Noise Reduction** → Reducir ruido de fondo (-20 dB)
2. **Normalize** → Estandarizar volumen (-3 dB)
3. **Compressor** → Controlar dinámica (ratio 3:1)
4. **EQ Paramétrico**:
   - High-pass: 80 Hz (cortar graves)
   - Boost: 2-5 kHz (+3 dB claridad)
5. **De-Esser** → Reducir sibilancias (6-8 kHz)
6. **Limiter** → Prevenir clipping (-0.5 dB)

### Herramientas Recomendadas

#### Gratuitas
- **Audacity** - Suite completa de edición
- **Audition (trial)** - 7 días gratis

#### Profesionales
- **Adobe Audition** - Estándar industria
- **iZotope RX** - Restauración avanzada
- **Waves Plugins** - Procesamiento vocal

### Exportar para Broadcast

```bash
# Convertir a formato broadcast
ffmpeg -i spot_generado.wav -ar 48000 -ab 320k -af loudnorm=I=-14:TP=-1.5 spot_final.mp3
```

**Especificaciones:**
- Sample Rate: 48000 Hz
- Bit Depth: 16-bit (broadcast) / 24-bit (master)
- LUFS Target: -14 LUFS (estándar radio/TV)

---

## ⚙️ Optimización

### Configuración Según Hardware

#### Solo CPU (sin GPU)

```python
import os
os.environ["SUNO_OFFLOAD_CPU"] = "True"
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
```

**Tiempo generación:** 30-120 segundos por spot

#### Con GPU NVIDIA (4+ GB VRAM)

```python
import os
os.environ["SUNO_OFFLOAD_CPU"] = "False"
```

**Tiempo generación:** Casi tiempo real

### Variables de Entorno

```python
# Cambiar ubicación de modelos
os.environ["HF_HOME"] = "/ruta/custom/cache"

# Forzar modo CPU
os.environ["SUNO_OFFLOAD_CPU"] = "True"

# Usar modelos pequeños
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
```

---

## 📚 Estructura del Proyecto

```
bark-tts-spots-estacionkus/
├── README.md                      # Este archivo
├── instalar_bark.sh               # Instalador Linux/macOS
├── instalar_bark.ps1              # Instalador Windows
├── generador_spots_avanzado.py    # Generador interactivo
├── procesamiento_lote.py          # Batch processing
├── spots_lote.json                # Ejemplo configuración lotes
├── config_estacionkus.json        # Config EstacionKusTV
└── LICENSE                        # Licencia MIT
```

---

## 🐛 Solución de Problemas

### Audio suena "telefónico" o baja calidad

**Causa:** Bark es generativo y puede producir variaciones de calidad.

**Soluciones:**
- Regenerar el mismo texto (resultado diferente cada vez)
- Usar preset de voz específico en lugar de aleatorio
- Aplicar post-producción agresiva (EQ, restauración)
- Generar 2-3 versiones y seleccionar la mejor

### Generación muy lenta

**Normal en CPU:** 30-120 segundos por spot de 10-13 seg.

**Optimizar:**
```python
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
```

### Error: CUDA out of memory

**Solución:**
```python
os.environ["SUNO_OFFLOAD_CPU"] = "True"
os.environ["SUNO_USE_SMALL_MODELS"] = "True"
```

### Modelos no se descargan

**Configurar cache manual:**
```bash
export HF_HOME=/ruta/con/espacio
python -c "from bark import preload_models; preload_models()"
```

---

## 📊 Especificaciones Técnicas

### Audio Generado por Bark

- **Sample Rate:** 24000 Hz
- **Bit Depth:** 16-bit PCM
- **Canales:** Mono
- **Formato:** WAV
- **Duración máxima:** ~13 segundos

### Audio Profesional (Recomendado)

- **Sample Rate:** 44100 Hz o 48000 Hz
- **Bit Depth:** 16-bit (broadcast) / 24-bit (producción)
- **Formatos:** WAV (master), MP3 320kbps (distribución)
- **LUFS Target:** -14 LUFS (broadcast), -16 LUFS (podcast)

---

## 🔗 Recursos

### Documentación Oficial

- **Bark GitHub:** [github.com/suno-ai/bark](https://github.com/suno-ai/bark)
- **HuggingFace:** [huggingface.co/suno/bark](https://huggingface.co/suno/bark)
- **Paper AudioLM:** [arxiv.org/abs/2209.03143](https://arxiv.org/abs/2209.03143)

### Comunidad

- **Discord Suno:** [suno.ai/discord](https://suno.ai/discord)
- **Catálogo Voces:** [Notion Voice Library](https://suno-ai.notion.site/8b8e8749ed514b0cbf3f699013548683)

### Tutoriales

- **Google Colab Demo:** [Colab Notebook](https://colab.research.google.com/drive/1eJfA2XUa-mXwdMy7DoYKVYHI1iTd9Vkt)
- **Optimización Bark:** [HuggingFace Blog](https://github.com/huggingface/blog/blob/main/optimizing-bark.md)

---

## 📝 Casos de Uso: EstacionKusTV

### 1. Spot Promocional Energético

```python
texto = '''
[WOMAN] ¡Atención Gen Z! [gasps]
EstacionKusTV trae el MEJOR contenido — 
noticias, entretenimiento y mucho más. [laughs]
Síguenos AHORA en todas las plataformas.
'''

audio = generate_audio(texto, history_prompt="v2/en_speaker_9")
```

### 2. Jingle de Identificación

```python
texto = "♪ EstacionKus Media, tu voz que inspira ♪"
audio = generate_audio(texto)  # Voz aleatoria para variedad
```

### 3. Narración de Noticias

```python
texto = '''
[MAN] En las noticias de hoy...
El gobierno anunció nuevas medidas. [clears throat]
Más detalles en nuestro sitio web.
'''

audio = generate_audio(texto, history_prompt="v2/es_speaker_1")
```

### 4. Workflow Diario EstacionKusTV

```bash
# Mañana: Generar spots del día
python3 procesamiento_lote.py

# Tarde: Post-producción en Audition
# - Aplicar pipeline completo
# - Exportar a 48kHz/320kbps

# Noche: Integrar con playout OBS
# - Cargar spots finalizados
# - Programar reproducción
```

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

1. Fork el proyecto
2. Crea tu rama de feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add: AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📜 Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo `LICENSE` para más detalles.

Bark (Suno AI) está licenciado bajo MIT License - disponible para **uso comercial**.

---

## 👥 Autores

**EstacionKusTV/EstacionKusMedia**
- Website: [estacionkusmedios.org](https://estacionkusmedios.org)
- GitHub: [@luisitoys12](https://github.com/luisitoys12)

**Powered by:**
- [Bark AI](https://github.com/suno-ai/bark) by Suno

---

## ⭐ Agradecimientos

- **Suno AI** - Por crear Bark y liberarlo como open-source
- **HuggingFace** - Por la integración con Transformers
- **Comunidad Bark** - Por compartir presets y mejores prácticas

---

## 📧 Contacto

¿Preguntas? ¿Sugerencias?

- **Email:** in3707989@gmail.com
- **Discord Suno:** [suno.ai/discord](https://suno.ai/discord)
- **Issues:** [GitHub Issues](https://github.com/luisitoys12/bark-tts-spots-estacionkus/issues)

---

<p align="center">
  <strong>🎙️ Crea spots profesionales con IA en minutos 🎙️</strong>
</p>

<p align="center">
  Made with ❤️ by EstacionKusTV/EstacionKusMedia
</p>
