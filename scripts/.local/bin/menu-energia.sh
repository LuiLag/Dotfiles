#!/usr/bin/env bash
# Barra horizontal flotante de energía (solo iconos, sin buscador)

BLOQUEAR=""
SUSPENDER=""
REINICIAR=""
APAGAR=""
SALIR=""

TEMA_BARRA='
window {
    width: 440px;
    padding: 16px;
    border-radius: 24px;
}
mainbox {
    children: [ listview ];
}
listview {
    columns: 5;
    lines: 1;
    spacing: 12px;
    fixed-height: true;
    fixed-columns: true;
}
element {
    orientation: vertical;
    padding: 16px 0px;
    border-radius: 18px;
}
element-icon {
    enabled: false;
}
element-text {
    font: "JetBrainsMono Nerd Font 20";
    horizontal-align: 0.5;
    vertical-align: 0.5;
}
'

ELECCION=$(echo -e "$BLOQUEAR\n$SUSPENDER\n$REINICIAR\n$APAGAR\n$SALIR" | rofi -dmenu -theme-str "$TEMA_BARRA")

case "$ELECCION" in
    "$BLOQUEAR")  hyprlock ;;
    "$SUSPENDER") systemctl suspend ;;
    "$REINICIAR") systemctl reboot ;;
    "$APAGAR")    systemctl poweroff ;;
    "$SALIR")     hyprctl dispatch exit ;;
esac
