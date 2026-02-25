#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Sistema de invitaciones Bark Studio Pro"""
import smtplib
import secrets
import json
from pathlib import Path
from datetime import datetime
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

class SistemaInvitaciones:
    def __init__(self):
        self.config_file = Path.home() / ".barkstudiopro" / "invitations.json"
        self.config_file.parent.mkdir(exist_ok=True)
        self.codigos_generados = self.cargar_codigos()
    
    def cargar_codigos(self):
        if self.config_file.exists():
            with open(self.config_file, 'r') as f:
                return json.load(f)
        return []
    
    def guardar_codigos(self):
        with open(self.config_file, 'w') as f:
            json.dump(self.codigos_generados, f, indent=2)
    
    def generar_codigo(self):
        return f"BARK-{secrets.token_hex(8).upper()}"
    
    def generar_multiples(self, cantidad=5, email_destino=None):
        codigos = []
        for _ in range(cantidad):
            codigo_data = {
                "codigo": self.generar_codigo(),
                "fecha_generacion": datetime.now().isoformat(),
                "email_destino": email_destino,
                "usado": False
            }
            codigos.append(codigo_data)
            self.codigos_generados.append(codigo_data)
        self.guardar_codigos()
        return codigos
    
    def validar_codigo(self, codigo):
        for item in self.codigos_generados:
            if item["codigo"] == codigo and not item["usado"]:
                item["usado"] = True
                item["fecha_uso"] = datetime.now().isoformat()
                self.guardar_codigos()
                return True
        return False

if __name__ == "__main__":
    sistema = SistemaInvitaciones()
    print("Sistema de Invitaciones - Bark Studio Pro")
    print("\nGenerando 5 códigos...")
    codigos = sistema.generar_multiples(5)
    for c in codigos:
        print(f"  {c['codigo']}")
    print(f"\nCódigos guardados en: {sistema.config_file}")
