#!/usr/bin/env bash
# Despliega un calendario limpio justo debajo del reloj de Waybar

# Si ya está abierto, lo cierra al volver a hacer clic en el reloj
if pgrep -x rofi >/dev/null; then
    pkill -x rofi
    exit 0
fi

python3 -c '
import calendar
from datetime import datetime
from zoneinfo import ZoneInfo

hoy = datetime.now(ZoneInfo("America/Merida"))
meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]

cal = calendar.Calendar(firstweekday=0)
semanas = cal.monthdayscalendar(hoy.year, hoy.month)

titulo = f"  {meses[hoy.month - 1]} {hoy.year}".center(26)
cabecera = "Lu  Ma  Mi  Ju  Vi  Sá  Do"
lineas = [titulo, "━━━━━━━━━━━━━━━━━━━━━━━━━━", cabecera]

for sem in semanas:
    fila = []
    for d in sem:
        if d == 0:
            fila.append("  ")
        elif d == hoy.day:
            # Resalta el día actual con corchetes
            fila.append(f"[{d:02d}]" if d < 10 else f"[{d}]")
        else:
            fila.append(f"{d:2d}")
    # Ajusta espaciado para que el día resaltado [26] no desplace la columna
    txt_fila = "  ".join(fila).replace(" [", "[").replace("] ", "]")
    lineas.append(txt_fila)

print("\n".join(lineas))
' | rofi -dmenu -no-custom -theme-str '
window {
    location: north;
    anchor: north;
    y-offset: 54px;
    width: 310px;
    border-radius: 24px;
    padding: 16px;
}
mainbox { children: [ listview ]; }
listview {
    lines: 9;
    spacing: 4px;
    dynamic: true;
}
element {
    children: [ element-text ];
    padding: 4px 8px;
    border-radius: 10px;
}
element selected.normal {
    background-color: transparent;
    border: none;
}
element-text {
    horizontal-align: 0.5;
    font: "JetBrainsMono Nerd Font Bold 12";
}
' >/dev/null 2>&1
