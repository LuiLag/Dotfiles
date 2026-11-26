#!/usr/bin/env bash
if pgrep -x hyprsunset >/dev/null; then
    pkill -x hyprsunset
    notify-send "Modo Noche" "Filtro de luz azul desactivado" -t 2000
else
    hyprsunset -t 4200 >/dev/null 2>&1 & disown
    notify-send "Modo Noche" "Filtro cálido activado (4200K)" -t 2000
fi
