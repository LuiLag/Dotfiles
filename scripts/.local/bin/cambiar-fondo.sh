#!/usr/bin/env bash
export PATH="$PATH:/usr/local/bin:/usr/sbin:$HOME/.local/bin"

DIR="$HOME/Pictures/Wallpapers"

# Estilo de galería compacta: miniaturas redondeadas y contorno ajustado
TEMA_GALERIA='
window {
    width: 460px;
    padding: 16px;
    border-radius: 20px;
}
mainbox {
    children: [ listview ];
}
listview {
    columns: 3;
    lines: 2;
    spacing: 10px;
    fixed-height: false;
    fixed-columns: true;
}
element {
    orientation: vertical;
    padding: 5px;
    border-radius: 15px;
}
element-icon {
    size: 115px;
    border-radius: 11px;
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
