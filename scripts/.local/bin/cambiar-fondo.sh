#!/usr/bin/env bash
export PATH="$PATH:/usr/local/bin:/usr/sbin:$HOME/.local/bin"

DIR="$HOME/Pictures/Wallpapers"

# Estilo de galería pura para Rofi: sin buscador, sin nombres, en cuadrícula (3 columnas x 2 filas)
TEMA_GALERIA='
window {
    width: 660px;
    padding: 20px;
}
mainbox {
    children: [ listview ];
}
listview {
    columns: 3;
    lines: 2;
    spacing: 14px;
    fixed-height: true;
    fixed-columns: true;
}
element {
    orientation: vertical;
    padding: 10px;
    border-radius: 16px;
}
element-icon {
    size: 165px;
    horizontal-align: 0.5;
    vertical-align: 0.5;
}
element-text {
    enabled: false;
}
'

# Lista las imágenes mostrando únicamente su miniatura en la cuadrícula
SELECCION=$(for img in "$DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$img" ] && echo -en "$(basename "$img")\0icon\x1f$img\n"
done | rofi -dmenu -i -theme-str "$TEMA_GALERIA")

if [ -n "$SELECCION" ]; then
    RUTA="$DIR/$SELECCION"
    
    # 1. Asegura que el motor awww-daemon esté corriendo
    if ! pgrep -x awww-daemon >/dev/null; then
        awww-daemon >/dev/null 2>&1 &
        sleep 0.3
    fi
    
    # 2. Cambia el fondo con desvanecimiento suave
    awww img "$RUTA" --transition-type fade --transition-duration 1.2 --transition-fps 60
    
    # 3. Genera los nuevos colores Material 3 automáticamente
    matugen image "$RUTA" --source-color-index 0
    
    # 4. Recarga Kitty, Waybar y Hyprland con la nueva paleta
    kill -SIGUSR1 $(pidof kitty) 2>/dev/null
    killall waybar 2>/dev/null
    waybar >/dev/null 2>&1 & disown
    hyprctl reload
    
    notify-send "Tema actualizado" "Aplicado desde: $SELECCION"
fi
