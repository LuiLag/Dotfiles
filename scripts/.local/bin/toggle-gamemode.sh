#!/usr/bin/env bash
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ]; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword decoration:rounding 0" >/dev/null
    notify-send "Modo Juego" "Activado: Animaciones y blur apagados para máximos FPS" -t 2500
else
    hyprctl reload >/dev/null
    notify-send "Modo Juego" "Desactivado: Estética Material 3 restaurada" -t 2500
fi
