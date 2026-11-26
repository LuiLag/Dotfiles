#!/usr/bin/env bash
# Selector de redes Wi-Fi en Rofi con colores dinámicos

notify-send "Wi-Fi" "Escaneando redes disponibles..." -t 2000
REDES=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | grep -v '^:' | sort -t: -k2 -nr | awk -F: '!seen[$1]++ {printf "  %s  (%s%%)\n", $1, $2}')

ELECCION=$(echo -e "  Activar/Desactivar Wi-Fi\n$REDES" | rofi -dmenu -i -p "Wi-Fi:" -theme-str 'window { width: 380px; } listview { lines: 7; }')

[ -z "$ELECCION" ] && exit 0

if [[ "$ELECCION" == *"Activar/Desactivar"* ]]; then
    ESTADO=$(nmcli radio wifi)
    [ "$ESTADO" = "enabled" ] && nmcli radio wifi off && notify-send "Wi-Fi" "Desactivado" || nmcli radio wifi on && notify-send "Wi-Fi" "Activado"
else
    SSID=$(echo "$ELECCION" | sed -E 's/^  (.*)  \([0-9]+%\)$/\1/')
    nmcli device wifi connect "$SSID" && notify-send "Wi-Fi" "Conectado a $SSID" || {
        CLAVE=$(rofi -dmenu -password -p "Contraseña para $SSID:" -theme-str 'window { width: 360px; } listview { lines: 0; }')
        [ -n "$CLAVE" ] && nmcli device wifi connect "$SSID" password "$CLAVE" && notify-send "Wi-Fi" "Conectado a $SSID"
    }
fi
