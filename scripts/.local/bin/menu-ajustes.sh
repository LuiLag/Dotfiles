#!/usr/bin/env bash
# Menú rápido y minimalista de Ajustes del Sistema en Rofi

OPCIONES="   Cambiar Wallpaper
   Editar Hyprland
   Editar Barra Superior
   Editar Centro de Control
   Editar Terminal
   Shortcuts
   Configurar Monitores
   Recargar Todo el Entorno
   Actualizar Sistema"

ELECCION=$(echo -e "$OPCIONES" | rofi -dmenu -theme-str '
window { width: 410px; border-radius: 24px; padding: 16px; }
mainbox { border: 0px; children: [ listview ]; }
listview { border: 0px; lines: 9; spacing: 6px; }
element { children: [ element-text ]; padding: 11px 16px; }
element-text { horizontal-align: 0.5; vertical-align: 0.5; }
')

[ -z "$ELECCION" ] && exit 0

case "$ELECCION" in
    *"Cambiar Wallpaper"*)
        ~/.local/bin/cambiar-fondo.sh
        ;;
    *"Editar Hyprland"*)
        kitty -e nvim ~/.config/hypr/hyprland.lua
        ;;
    *"Editar Barra"*)
        kitty -e nvim ~/.config/waybar/config.jsonc ~/.config/waybar/style.css
        ;;
    *"Editar Centro"*)
        kitty -e nvim ~/.config/swaync/config.json ~/.config/swaync/style.css
        ;;
    *"Editar Terminal"*)
        kitty -e nvim ~/.config/kitty/kitty.conf
        ;;
    *"Shortcuts"*)
        ~/.local/bin/ver-shortcuts.sh
        ;;
    *"Configurar Monitores"*)
        MONS=$(hyprctl monitors | grep "Monitor " | awk '{print $2}')
        SEL_MON=$(echo "$MONS" | rofi -dmenu -theme-str 'window { width: 320px; } mainbox { children: [ listview ]; } listview { lines: 3; } element { children: [ element-text ]; } element-text { horizontal-align: 0.5; }')
        [ -n "$SEL_MON" ] && notify-send "Monitor $SEL_MON" "$(hyprctl monitors | grep -A 3 "Monitor $SEL_MON")"
        ;;
    *"Recargar Todo"*)
        hyprctl reload >/dev/null 2>&1
        kill -SIGUSR2 $(pidof waybar) 2>/dev/null
        swaync-client -R && swaync-client -rs >/dev/null 2>&1
        notify-send "Sistema Recargado" "Hyprland, Waybar y SwayNC actualizados" -t 2000
        ;;
    *"Actualizar Sistema"*)
        kitty -e bash -c "sudo pacman -Syu; echo ''; read -p 'Presiona Enter para cerrar...'"
        ;;
esac
