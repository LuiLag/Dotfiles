#!/usr/bin/env bash
# Menú minimalista de Bluetooth en Rofi (sin buscador, estilo Material 3)

ESTADO=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$ESTADO" = "yes" ]; then
    TOGGLE="  Apagar Bluetooth"
    # Lista dispositivos emparejados con su estado de conexión
    DISPOSITIVOS=$(bluetoothctl devices | while read -r _ MAC NOMBRE; do
        if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
            echo "    $NOMBRE (Conectado)|$MAC"
        else
            echo "  $NOMBRE|$MAC"
        fi
    done)
else
    TOGGLE="  Encender Bluetooth"
    DISPOSITIVOS=""
fi

LISTA=$(echo -e "$TOGGLE\n$DISPOSITIVOS" | sed '/^$/d')
VISUAL=$(echo "$LISTA" | cut -d'|' -f1)

ELECCION=$(echo "$VISUAL" | rofi -dmenu -theme-str '
window { width: 360px; border-radius: 22px; padding: 14px; }
mainbox { children: [ listview ]; }
listview { lines: 5; spacing: 6px; }
')

[ -z "$ELECCION" ] && exit 0

if [[ "$ELECCION" == *"Encender Bluetooth"* ]]; then
    bluetoothctl power on && notify-send "Bluetooth" "Encendido"
elif [[ "$ELECCION" == *"Apagar Bluetooth"* ]]; then
    bluetoothctl power off && notify-send "Bluetooth" "Apagado"
else
    MAC=$(echo "$LISTA" | grep -F "$ELECCION|" | cut -d'|' -f2)
    if [[ "$ELECCION" == *"(Conectado)"* ]]; then
        bluetoothctl disconnect "$MAC" && notify-send "Bluetooth" "Desconectado"
    else
        notify-send "Bluetooth" "Conectando..." -t 1500
        bluetoothctl connect "$MAC" && notify-send "Bluetooth" "Conectado" || notify-send "Bluetooth" "No se pudo conectar"
    fi
fi
