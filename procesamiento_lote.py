#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PROCESAMIENTO POR LOTES
Generación múltiple de spots desde JSON
EstacionKusTV/EstacionKusMedia
"""

import os
import sys
import json
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

def cargar_lote(archivo="spots_lote.json"):
    """Cargar spots desde archivo JSON"""
    try:
        with open(archivo, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data.get('spots', [])
    except FileNotFoundError:
        print(f"ERROR: Archivo {archivo} no encontrado")
        print("\nEjemplo de formato:")
        print(json.dumps({
            "spots": [
                {
                    "nombre": "promo_matutino",
                    "texto": "Buenos días EstacionKusTV...",
                    "voz": "v2/es_speaker_1"
                },
                {
                    "nombre": "jingle_corto",
                    "texto": "♪ EstacionKus ♪",
                    "voz": None
                }
            ]
        }, indent=2, ensure_ascii=False))
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"ERROR: Formato JSON inválido: {e}")
        sys.exit(1)

def procesar_lote(spots, output_dir=None):
    """Procesar lista de spots"""
    if not output_dir:
        output_dir = Path.home() / "BarkStudioPro" / "Audio"
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Configurar para CPU
    os.environ["SUNO_USE_SMALL_MODELS"] = "True"
    os.environ["SUNO_OFFLOAD_CPU"] = "True"
    
    print("Cargando modelos de Bark AI...")
    preload_models()
    print("Modelos cargados\n")
    
    total = len(spots)
    exitosos = 0
    fallidos = 0
    
    for i, spot in enumerate(spots, 1):
        print(f"\n[{i}/{total}] Procesando: {spot.get('nombre', f'spot_{i}')}")
        print("-" * 60)
        
        texto = spot.get('texto', '')
        voz = spot.get('voz')
        nombre = spot.get('nombre', f'spot_lote_{i}')
        
        if not texto:
            print("  ERROR: Spot sin texto")
            fallidos += 1
            continue
        
        try:
            # Generar audio
            if voz:
                audio = generate_audio(texto, history_prompt=voz)
            else:
                audio = generate_audio(texto)
            
            # Normalizar
            audio = audio / np.max(np.abs(audio)) * 0.95
            
            # Guardar
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"{nombre}_{timestamp}.wav"
            filepath = output_dir / filename
            write_wav(str(filepath), SAMPLE_RATE, audio)
            
            print(f"  ✓ Generado: {filename}")
            exitosos += 1
            
        except Exception as e:
            print(f"  ✗ ERROR: {e}")
            fallidos += 1
    
    # Resumen
    print("\n" + "=" * 60)
    print("RESUMEN DEL PROCESAMIENTO")
    print("=" * 60)
    print(f"Total spots: {total}")
    print(f"Exitosos: {exitosos}")
    print(f"Fallidos: {fallidos}")
    print(f"\nArchivos guardados en: {output_dir}")
    print("=" * 60)

def main():
    print("=" * 60)
    print("  PROCESAMIENTO POR LOTES - BARK STUDIO PRO")
    print("  EstacionKusTV/EstacionKusMedia")
    print("=" * 60)
    print()
    
    # Buscar archivo de lote
    archivo = "spots_lote.json"
    if len(sys.argv) > 1:
        archivo = sys.argv[1]
    
    print(f"Cargando spots desde: {archivo}\n")
    spots = cargar_lote(archivo)
    
    if not spots:
        print("No se encontraron spots para procesar")
        sys.exit(1)
    
    print(f"Se procesaran {len(spots)} spots\n")
    input("Presiona Enter para continuar...")
    
    procesar_lote(spots)
    
    print("\n¡Procesamiento completado!")

if __name__ == "__main__":
    main()
