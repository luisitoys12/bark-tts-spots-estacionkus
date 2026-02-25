#!/usr/bin/env python3
'''
PROCESAMIENTO POR LOTES - MÚLTIPLES SPOTS
EstacionKusTV/EstacionKusMedia
'''

import os
import json
from bark import SAMPLE_RATE, generate_audio, preload_models
from scipy.io.wavfile import write as write_wav

def procesar_lote(archivo_json):
    '''Procesa múltiples spots desde archivo JSON'''
    
    print("→ Cargando modelos...")
    os.environ["SUNO_USE_SMALL_MODELS"] = "True"
    preload_models()
    
    # Leer configuración
    with open(archivo_json, 'r', encoding='utf-8') as f:
        config = json.load(f)
    
    spots = config.get('spots', [])
    print(f"\n✓ {len(spots)} spots en cola\n")
    
    # Procesar cada spot
    for i, spot in enumerate(spots, 1):
        nombre = spot.get('nombre', f'spot_{i}')
        texto = spot.get('texto', '')
        voz = spot.get('voz', None)
        
        print(f"[{i}/{len(spots)}] Generando: {nombre}")
        
        if voz:
            audio = generate_audio(texto, history_prompt=voz)
        else:
            audio = generate_audio(texto)
        
        output = f"{nombre}.wav"
        write_wav(output, SAMPLE_RATE, audio)
        print(f"  ✓ Guardado: {output}\n")
    
    print("="*50)
    print(f"✓ LOTE COMPLETADO: {len(spots)} spots generados")
    print("="*50)

# Ejemplo de uso
ejemplo_json = {
    "spots": [
        {
            "nombre": "promo_matutino",
            "texto": "¡Buenos días! Sintoniza EstacionKusTV cada mañana.",
            "voz": "v2/es_speaker_1"
        },
        {
            "nombre": "jingle_corto",
            "texto": "♪ EstacionKus, tu voz Gen Z ♪",
            "voz": None
        }
    ]
}

if __name__ == "__main__":
    # Crear ejemplo si no existe
    if not os.path.exists('spots_lote.json'):
        with open('spots_lote.json', 'w', encoding='utf-8') as f:
            json.dump(ejemplo_json, f, indent=2, ensure_ascii=False)
        print("✓ Archivo de ejemplo creado: spots_lote.json")
        print("  Edítalo y vuelve a ejecutar este script\n")
    else:
        procesar_lote('spots_lote.json')
