#!/usr/bin/env bash
# Selector rápido de salidas de audio en Rofi (sin buscador, estilo Material 3)

# Extrae las salidas (Sinks) activas de PipeWire con su ID y nombre limpio
SALIDAS=$(wpctl status | awk '
    /Sinks:/ { flag=1; next }
    /Sources:|Filters:|Streams:/ { flag=0 }
    flag && /[0-9]+\./ {
        activo = ($0 ~ /\*/) ? "  " : "   "
        gsub(/^[ │*]+/, "", $0)
        split($0, a, ".")
        id = a[1]
        sub(/^[0-9]+\.[ ]*/, "", $0)
        sub(/ \[vol:.*$/, "", $0)
        printf "%s%s|%s\n", activo, $0, id
    }
')

VISUAL=$(echo "$SALIDAS" | cut -d'|' -f1)

ELECCION=$(echo "$VISUAL" | rofi -dmenu -theme-str '
window { width: 420px; border-radius: 22px; padding: 14px; }
mainbox { children: [ listview ]; }
listview { lines: 4; spacing: 6px; }
')

[ -z "$ELECCION" ] && exit 0

ID=$(echo "$SALIDAS" | grep -F "$ELECCION|" | cut -d'|' -f2)
NOMBRE=$(echo "$ELECCION" | sed 's/^[ ]*//')

if [ -n "$ID" ]; then
    wpctl set-default "$ID"
    notify-send "Salida de Audio" "Cambiado a: $NOMBRE" -t 2000
fi
