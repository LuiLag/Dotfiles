#!/usr/bin/env bash
export PATH="$PATH:/usr/local/bin:/usr/bin:/usr/sbin:$HOME/.local/bin"

DIR="$HOME/Pictures/Wallpapers"

WP_1="$DIR/Programming.jpg"  # Escritorio 1: Programar
WP_2="$DIR/Browser.jpg"      # Escritorio 2: Navegar
WP_3="$DIR/Gaming.jpg"       # Escritorio 3: Jugar
WP_4="$DIR/Music.jpg"        # Escritorio 4: Música
WP_5="$DIR/General.jpg"      # Escritorio 5: Varios

ULTIMO_WS=""

cambiar_fondo() {
    INFO=$(hyprctl activeworkspace)
    WS=$(echo "$INFO" | head -n 1 | awk '{print $2}')
    MON=$(echo "$INFO" | head -n 1 | awk '{print $6}' | tr -d ':')

    # Si el escritorio no cambió (por ejemplo, solo moviste el mouse entre monitores), no hace nada
    [ "$WS" = "$ULTIMO_WS" ] && return
    ULTIMO_WS="$WS"

    local IMG=""
    case "$WS" in
        1) IMG="$WP_1" ;;
        2) IMG="$WP_2" ;;
        3) IMG="$WP_3" ;;
        4) IMG="$WP_4" ;;
        5) IMG="$WP_5" ;;
        *) return ;;
    esac

    if [ -f "$IMG" ] && [ -n "$MON" ]; then
        awww img "$IMG" -o "$MON" --transition-type none &
        matugen image "$IMG" -m dark --source-color-index 0 >/dev/null 2>&1

        PRI=$(grep "@define-color primary " ~/.cache/matugen/colors-waybar.css | awk '{print $3}' | tr -d ';#')
        [ -n "$PRI" ] && hyprctl keyword general:col.active_border "rgb($PRI)" >/dev/null 2>&1

        kill -SIGUSR1 $(pidof kitty) 2>/dev/null
        kill -SIGUSR2 $(pidof waybar) 2>/dev/null
        pgrep -x swaync >/dev/null && swaync-client -rs >/dev/null 2>&1
    fi
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" 2>/dev/null | while read -r linea; do
    if [[ "$linea" == workspace\>\>* ]]; then
        cambiar_fondo
    fi
done
