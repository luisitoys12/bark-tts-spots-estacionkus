#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GENERADOR DE SPOTS AVANZADO
EstacionKusTV/EstacionKusMedia
"""

import os
import sys
from datetime import datetime
from pathlib import Path

try:
    from bark import SAMPLE_RATE, generate_audio, preload_models
    from scipy.io.wavfile import write as write_wav
    import numpy as np
except ImportError:
    print("ERROR: Dependencias no instaladas")
    print("Ejecuta primero el instalador")
    sys.exit(1)

class GeneradorSpots:
    def __init__(self):
        self.audio_dir = Path.home() / "BarkStudioPro" / "Audio"
        self.audio_dir.mkdir(parents=True, exist_ok=True)
        
        # Configurar para CPU
        os.environ["SUNO_USE_SMALL_MODELS"] = "True"
        os.environ["SUNO_OFFLOAD_CPU"] = "True"
        
    def cargar_modelos(self):
        print("Cargando modelos de Bark AI...")
        print("(Primera vez puede tardar varios minutos)\n")
        preload_models()
        print("Modelos cargados correctamente\n")
    
    def generar_spot(self, texto, voz=None, nombre=None):
        print(f"Generando audio...")
        print(f"Texto: {texto[:50]}..." if len(texto) > 50 else f"Texto: {texto}")
        
        if voz:
            print(f"Voz: {voz}")
            audio = generate_audio(texto, history_prompt=voz)
        else:
            print("Voz: Aleatoria")
            audio = generate_audio(texto)
        
        # Normalizar audio
        audio = audio / np.max(np.abs(audio)) * 0.95
        
        # Generar nombre de archivo
        if not nombre:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            nombre = f"spot_{timestamp}"
        
        # Guardar
        filepath = self.audio_dir / f"{nombre}.wav"
        write_wav(str(filepath), SAMPLE_RATE, audio)
        
        print(f"\nAudio generado: {filepath}")
        return filepath
    
    def mostrar_voces(self):
        print("\nVOCES DISPONIBLES PARA ESPAÑOL:")
        print("=" * 50)
        print("v2/es_speaker_0 - Masculino Neutro")
        print("v2/es_speaker_1 - Masculino Narrador")
        print("v2/es_speaker_2 - Femenino Suave")
        print("v2/es_speaker_3 - Masculino Joven")
        print("v2/es_speaker_4 - Femenino Profesional")
        print("v2/es_speaker_5 - Masculino Energético")
        print("v2/es_speaker_6 - Femenino Amigable")
        print("v2/es_speaker_7 - Masculino Serio")
        print("v2/es_speaker_8 - Femenino Juvenil")
        print("v2/es_speaker_9 - Masculino Casual")
        print("\n(Deja vacío para voz aleatoria)")
        print("=" * 50)

def main():
    print("=" * 60)
    print("  GENERADOR DE SPOTS - BARK STUDIO PRO")
    print("  EstacionKusTV/EstacionKusMedia")
    print("=" * 60)
    print()
    
    generador = GeneradorSpots()
    
    # Cargar modelos
    generador.cargar_modelos()
    
    while True:
        print("\n" + "=" * 60)
        print("NUEVO SPOT")
        print("=" * 60)
        
        # Pedir guión
        print("\nEscribe tu guión (Enter 2 veces para finalizar):")
        lineas = []
        while True:
            linea = input()
            if linea == "":
                break
            lineas.append(linea)
        
        texto = "\n".join(lineas)
        
        if not texto.strip():
            print("No se ingresó texto. Saliendo...")
            break
        
        # Mostrar voces
        generador.mostrar_voces()
        
        # Pedir voz
        voz_input = input("\nVoz (Enter para aleatoria): ").strip()
        voz = voz_input if voz_input else None
        
        # Pedir nombre
        nombre_input = input("Nombre del archivo (Enter para automático): ").strip()
        nombre = nombre_input if nombre_input else None
        
        # Generar
        print("\n" + "-" * 60)
        try:
            filepath = generador.generar_spot(texto, voz, nombre)
            print("-" * 60)
            print("\n✓ SPOT GENERADO EXITOSAMENTE")
            print(f"\nArchivo: {filepath}")
        except Exception as e:
            print(f"\nERROR: {e}")
        
        # Preguntar si continuar
        continuar = input("\n¿Generar otro spot? (s/n): ").strip().lower()
        if continuar != 's':
            break
    
    print("\n¡Gracias por usar Bark Studio Pro!")
    print("EstacionKusTV/EstacionKusMedia\n")

if __name__ == "__main__":
    main()
