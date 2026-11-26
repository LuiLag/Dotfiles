#!/usr/bin/env bash
pkill -9 -f "[c]onky" 2>/dev/null

python3 -c '
import json, subprocess, re
from datetime import datetime
from zoneinfo import ZoneInfo

ahora = datetime.now(ZoneInfo("America/Merida"))
hora_local = ahora.strftime("%I:%M %p")

dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
meses = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]
fecha_es = f"{dias[ahora.weekday()]}, {ahora.day} de {meses[ahora.month - 1]}"

up_raw = subprocess.getoutput("uptime -p")
h = re.search(r"(\d+)\s+hour", up_raw)
m = re.search(r"(\d+)\s+minute", up_raw)
up = f"{h.group(1)}h {m.group(1)}m" if h and m else (f"{m.group(1)}m" if m else "Activo")

try:
    clima = open("/tmp/clima_merida.txt").read().strip()
except:
    clima = "Despejado"

cdmx = datetime.now(ZoneInfo("America/Mexico_City")).strftime("%I:%M %p")
tokio = datetime.now(ZoneInfo("Asia/Tokyo")).strftime("%I:%M %p")
madrid = datetime.now(ZoneInfo("Europe/Madrid")).strftime("%I:%M %p")
seul = datetime.now(ZoneInfo("Asia/Seoul")).strftime("%I:%M %p")

def centrar(texto, ancho=33):
    visual_len = sum(2 if ord(c) > 0x2000 and c != "━" and c != "•" else 1 for c in texto)
    izq = max(0, (ancho - visual_len) // 2)
    return (" " * izq) + texto

sep = "━" * 33
texto_perfil = "\n".join([
    centrar(f"  LuiLag • Up {up}"),
    centrar("  Mérida, Yucatán"),
    sep,
    centrar(hora_local),
    centrar(fecha_es),
    sep,
    centrar(f"CDMX:  {cdmx}  Tokio: {tokio}"),
    centrar(f"Madrid:{madrid}  Seúl:  {seul}")
])

clima_txt = f"  {clima}"
esp_izq = max(0, (48 - len(clima_txt)) // 2)

p = "/home/lu/.config/swaync/config.json"
d = json.load(open(p, encoding="utf-8"))
d["widget-config"]["label"]["text"] = texto_perfil
d["widget-config"]["title"]["text"] = "\u2800" + (" " * esp_izq) + clima_txt
json.dump(d, open(p, "w", encoding="utf-8"), indent=2, ensure_ascii=False)
'

swaync-client -R >/dev/null 2>&1
swaync-client -t -sw >/dev/null 2>&1
(~/.local/bin/clima-merida.sh >/dev/null 2>&1) &
