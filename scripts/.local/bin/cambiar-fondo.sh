#!/usr/bin/env bash
export PATH="$PATH:/usr/local/bin:/usr/sbin:$HOME/.local/bin"

# --- 1. RUTAS DE WALLPAPERS Y CACHÉ DE MINIATURAS ---
DIR="$HOME/Pictures/Wallpapers"
CACHE="$HOME/.cache/wallpaper-thumbs"
mkdir -p "$CACHE"

# --- 2. GENERACIÓN DE MINIATURAS REDONDEADAS (4:3) ---
python3 - "$DIR" "$CACHE" << 'PYEOF'
import sys, os
from PIL import Image, ImageDraw, ImageOps

src_dir, cache_dir = sys.argv[1], sys.argv[2]
size = (160, 115)
radius = 18

for fname in os.listdir(src_dir):
    if not fname.lower().endswith(('.jpg', '.jpeg', '.png', '.webp')):
        continue
    src_path = os.path.join(src_dir, fname)
    thumb_path = os.path.join(cache_dir, os.path.splitext(fname)[0] + ".png")
    
    if not os.path.exists(thumb_path) or os.path.getmtime(src_path) > os.path.getmtime(thumb_path):
        with Image.open(src_path).convert("RGBA") as img:
            thumb = ImageOps.fit(img, size, method=Image.Resampling.LANCZOS)
            mask = Image.new("L", size, 0)
            draw = ImageDraw.Draw(mask)
            draw.rounded_rectangle((0, 0, size[0], size[1]), radius=radius, fill=255)
            thumb.putalpha(mask)
            thumb.save(thumb_path, "PNG")
PYEOF

# --- 3. ESTILO DE CUADRÍCULA EN ROFI ---
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

# --- 4. SELECTOR INTERACTIVO ---
SELECCION=$(for img in "$DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$img" ] || continue
    nombre=$(basename "$img")
    miniatura="$CACHE/${nombre%.*}.png"
    echo -en "$nombre\0icon\x1f$miniatura\n"
done | rofi -dmenu -i -theme-str "$TEMA_GALERIA")

# --- 5. APLICACIÓN DEL FONDO Y RECARGA DEL ENTORNO ---
if [ -n "$SELECCION" ]; then
    RUTA="$DIR/$SELECCION"
    
    # Inicia awww-daemon si aún no está corriendo
    if ! pgrep -x awww-daemon >/dev/null; then
        awww-daemon >/dev/null 2>&1 &
        sleep 0.3
    fi
    
    # Cambia el wallpaper con transición suave
    awww img "$RUTA" --transition-type fade --transition-duration 1.2 --transition-fps 60
    
    # Genera paleta oscura Material 3 (actualiza Kitty, Waybar, Rofi, btop y Spotify)
    matugen image "$RUTA" -m dark --source-color-index 0 >/dev/null 2>&1
    
    # Recarga limpia sin generar archivos residuales
    kill -SIGUSR1 $(pidof kitty) 2>/dev/null || true
    swaync-client -rs >/dev/null 2>&1 || true
    killall waybar 2>/dev/null || true
    waybar >/dev/null 2>&1 & disown
    hyprctl reload >/dev/null 2>&1
    
    notify-send "Tema actualizado" "Aplicado desde: $SELECCION" -t 2500
fi
