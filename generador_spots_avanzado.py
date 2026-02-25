#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''
GENERADOR AVANZADO DE SPOTS PUBLICITARIOS
EstacionKusTV/EstacionKusMedia - Powered by Bark AI
'''

import os
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav
import numpy as np

class GeneradorSpots:
    def __init__(self):
        print("="*60)
        print("GENERADOR DE SPOTS PUBLICITARIOS - BARK AI")
        print("EstacionKusTV/EstacionKusMedia")
        print("="*60)
        
        # Optimización según hardware
        usar_gpu = input("\n¿Tienes GPU NVIDIA? (s/n): ").lower() == 's'
        if not usar_gpu:
            os.environ["SUNO_OFFLOAD_CPU"] = "True"
            os.environ["SUNO_USE_SMALL_MODELS"] = "True"
            print("→ Modo CPU activado (más lento pero funcional)")
        else:
            print("→ Modo GPU activado (más rápido)")
        
        print("\n→ Cargando modelos de IA...")
        preload_models()
        print("✓ Modelos listos\n")
    
    def mostrar_voces(self):
        '''Catálogo de voces disponibles'''
        voces = {
            # Voces en inglés
            "en_1": {"preset": "v2/en_speaker_0", "desc": "Masculino profesional"},
            "en_2": {"preset": "v2/en_speaker_1", "desc": "Masculino casual"},
            "en_3": {"preset": "v2/en_speaker_6", "desc": "Masculino energético"},
            "en_4": {"preset": "v2/en_speaker_9", "desc": "Femenino profesional"},
            # Voces en español
            "es_1": {"preset": "v2/es_speaker_0", "desc": "Español neutro"},
            "es_2": {"preset": "v2/es_speaker_1", "desc": "Español narrador"},
            # Otras lenguas
            "de_1": {"preset": "v2/de_speaker_0", "desc": "Alemán"},
            "fr_1": {"preset": "v2/fr_speaker_1", "desc": "Francés"},
            "random": {"preset": None, "desc": "Voz aleatoria (experimental)"}
        }
        
        print("\n→ VOCES DISPONIBLES:")
        for key, info in voces.items():
            print(f"  {key}: {info['desc']}")
        
        return voces
    
    def generar_spot(self):
        '''Generador interactivo de spots'''
        
        # Configuración básica
        nombre = input("\nNombre del proyecto: ")
        
        # Selección de voz
        voces = self.mostrar_voces()
        voz_id = input("\nSelecciona voz (ej: en_3, es_1): ")
        preset = voces.get(voz_id, {}).get("preset")
        
        # Instrucciones de formato
        print("\n" + "="*60)
        print("TIPS PARA MEJOR CALIDAD:")
        print("="*60)
        print("• [laughs] - risas")
        print("• [sighs] - suspiros")
        print("• [music] - música de fondo")
        print("• [gasps] - jadeos/sorpresa")
        print("• [clears throat] - aclarar garganta")
        print("• MAYÚSCULAS - énfasis en palabra")
        print("• ... o — - pausas/hesitación")
        print("• ♪ texto ♪ - cantar/jingle")
        print("• [MAN] o [WOMAN] - sesgar género voz")
        print("="*60)
        
        # Entrada de texto
        print("\nIngresa el texto del spot (máximo 13 segundos de habla):")
        print("Presiona Enter dos veces cuando termines\n")
        
        lines = []
        while True:
            line = input()
            if line == "":
                if lines:
                    break
            else:
                lines.append(line)
        
        texto_spot = " ".join(lines)
        
        # Generar audio
        print("\n→ Generando spot publicitario...")
        print("   (Esto puede tardar 30-120 segundos)\n")
        
        if preset:
            audio = generate_audio(texto_spot, history_prompt=preset)
        else:
            audio = generate_audio(texto_spot)
        
        # Guardar archivo
        output_file = f"{nombre}_spot.wav"
        write_wav(output_file, SAMPLE_RATE, audio)
        
        duracion = len(audio) / SAMPLE_RATE
        
        print("\n" + "="*60)
        print("✓ SPOT GENERADO EXITOSAMENTE")
        print("="*60)
        print(f"Archivo: {output_file}")
        print(f"Duración: {duracion:.2f} segundos")
        print(f"Sample Rate: {SAMPLE_RATE} Hz")
        print(f"Tamaño: {len(audio)} samples")
        
        # Recomendaciones post-producción
        print("\n→ SIGUIENTE PASO: POST-PRODUCCIÓN")
        print("   Abre el archivo en Audacity o Adobe Audition")
        print("\n   Pipeline recomendado:")
        print("   1. Noise Reduction (Reducción de ruido)")
        print("   2. Normalize a -3.0 dB (Normalización)")
        print("   3. Compressor 3:1 ratio (Compresión)")
        print("   4. EQ: Boost 2-5 kHz, Cut <80 Hz")
        print("   5. Limiter a -0.5 dB (Limitador)")
        print("="*60)
        
        return output_file

if __name__ == "__main__":
    generador = GeneradorSpots()
    generador.generar_spot()
    
    # Opción de generar más
    while input("\n¿Generar otro spot? (s/n): ").lower() == 's':
        generador.generar_spot()
    
    print("\n¡Gracias por usar Bark AI!")
