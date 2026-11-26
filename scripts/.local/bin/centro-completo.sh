#!/usr/bin/env bash
# Alterna SwayNC y Conky al mismo tiempo, y cierra Conky si ocultas SwayNC con Esc

if pgrep -f "[c]onky" >/dev/null; then
    pkill -9 -f "[c]onky" 2>/dev/null
    pkill -f "swaync-client -s" 2>/dev/null
    swaync-client -t -sw >/dev/null 2>&1
else
    # 1. Arranca Conky primero y abre SwayNC en el mismo instante
    LC_TIME=es_MX.UTF-8 conky -d >/dev/null 2>&1
    swaync-client -t -sw >/dev/null 2>&1

    # 2. Actualiza clima en segundo plano
    (curl -s --max-time 4 "wttr.in/Merida?m&format=%t+%C&lang=es" | sed 's/+//' > /tmp/clima_merida.txt) &

    # 3. Espera 0.4s a que SwayNC ya esté abierto y vigila cuando lo cierres con Esc
    (
        sleep 0.4
        swaync-client -s | while read -r linea; do
            if [[ "$linea" == *'"visible": false'* ]]; then
                pkill -9 -f "[c]onky" 2>/dev/null
                break
            fi
        done
    ) &
fi
