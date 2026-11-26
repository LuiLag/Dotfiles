#!/usr/bin/env bash
if pgrep -x hypridle >/dev/null; then
    pkill -x hypridle
    notify-send "Modo Cafetera" "Activado: La pantalla no se bloqueará ni apagará sola" -t 2500
else
    hypridle >/dev/null 2>&1 & disown
    notify-send "Modo Cafetera" "Desactivado: Bloqueo automático restaurado" -t 2500
fi
