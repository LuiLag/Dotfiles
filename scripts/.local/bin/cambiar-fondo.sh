#!/usr/bin/env bash
export PATH="$PATH:/usr/local/bin:/usr/sbin:$HOME/.local/bin"

DIR="$HOME/Pictures/Wallpapers"

# Lista las imágenes mostrando su miniatura en Rofi
SELECCION=$(for img in "$DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$img" ] && echo -en "$(basename "$img")\0icon\x1f$img\n"
done | rofi -dmenu -i -p "Fondo:" -theme-str 'listview { columns: 2; lines: 3; } element-icon { size: 96px; }')

if [ -n "$SELECCION" ]; then
    RUTA="$DIR/$SELECCION"
    
    # 1. Asegura que el motor awww-daemon esté corriendo
    if ! pgrep -x awww-daemon >/dev/null; then
        awww-daemon >/dev/null 2>&1 &
        sleep 0.3
    fi
    
    # 2. Cambia el fondo con desvanecimiento suave (fade)
    awww img "$RUTA" --transition-type fade --transition-duration 1.2 --transition-fps 60
    
    # 3. Genera la paleta Material 3 automáticamente sin pedir confirmación (--source-color-index 0)
    matugen image "$RUTA" --source-color-index 0
    
    # 4. Recarga los colores en Kitty, Waybar y Hyprland
    kill -SIGUSR1 $(pidof kitty) 2>/dev/null
    killall waybar 2>/dev/null
    waybar >/dev/null 2>&1 & disown
    hyprctl reload
    
    notify-send "Tema actualizado" "Aplicado desde: $SELECCION"
fi
