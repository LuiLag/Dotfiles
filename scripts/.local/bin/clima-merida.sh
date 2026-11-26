#!/usr/bin/env bash
CLIMA=$(curl -s --max-time 3 "wttr.in/Merida?m&format=%t+%C&lang=es" | sed 's/+//')
[ -n "$CLIMA" ] && echo "$CLIMA" > /tmp/clima_merida.txt
cat /tmp/clima_merida.txt 2>/dev/null || echo "28°C Despejado"
