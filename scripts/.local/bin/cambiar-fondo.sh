#!/usr/bin/env bash
export PATH="$PATH:/usr/local/bin:/usr/sbin:$HOME/.local/bin"

DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wallpaper-thumbs"
mkdir -p "$CACHE"

# Genera miniaturas recortadas (4:3) con esquinas redondeadas transparentes en caché
python3 - "$DIR" "$CACHE" << 'PYEOF'
import sys, os
from PIL import Image, ImageDraw, ImageOps

src_dir, cache_dir = sys.argv[1], sys.argv[2]
size = (160, 115)  # Proporción compacta que llena bien el recuadro de selección
radius = 18        # Radio de redondeo de las esquinas de la imagen

for fname in os.listdir(src_dir):
    if not fname.lower().endswith(('.jpg', '.jpeg', '.png', '.webp')):
        continue
    src_path = os.path.join(src_dir, fname)
    thumb_path = os.path.join(cache_dir, os.path.splitext(fname)[0] + ".png")
    
    # Solo genera la miniatura si no existe o si la imagen original cambió
    if not os.path.exists(thumb_path) or os.path.getmtime(src_path) > os.path.getmtime(thumb_path):
        with Image.open(src_path).convert("RGBA") as img:
            thumb = ImageOps.fit(img, size, method=Image.Resampling.LANCZOS)
            mask = Image.new("L", size, 0)
            draw = ImageDraw.Draw(mask)
            draw.rounded_rectangle((0, 0, size[0], size[1]), radius=radius, fill=255)
            thumb.putalpha(mask)
            thumb.save(thumb_path, "PNG")
PYEOF

# Estilo de galería compacta ajustada exactamente a la miniatura
TEMA_GALERIA='
window {
    width: 460px;
    padding: 16px;
    border-radius: 22px;
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
    border-radius: 18px;
}
element-icon {
    size: 115px;
    horizontal-align: 0.5;
    vertical-align: 0.5;
}
element-text {
    enabled: false;
}
'

# Muestra cada imagen usando su miniatura redondeada como icono
SELECCION=$(for img in "$DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$img" ] || continue
    nombre=$(basename "$img")
    miniatura="$CACHE/${nombre%.*}.png"
    echo -en "$nombre\0icon\x1f$miniatura\n"
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
