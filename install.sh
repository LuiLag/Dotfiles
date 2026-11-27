#!/usr/bin/env bash
set -e

echo "======================================================"
echo "  Instalador Automático - Dotfiles Arch + Hyprland"
echo "======================================================"

# ============================================================================
# 1. LISTA DE PAQUETES OFICIALES NECESARIOS (PACMAN)
# ============================================================================
PAQUETES=(
    hyprland hyprlock hypridle hyprpicker hyprsunset
    waybar swaync rofi-wayland kitty neovim conky btop
    matugen awww cliphist wl-clipboard grim slurp
    playerctl curl socat jq usbutils bluez bluez-utils
    yazi eza starship fastfetch python-pillow
    ttf-jetbrains-mono-nerd papirus-icon-theme stow
)

echo "-> Instalando paquetes base con pacman..."
sudo pacman -S --needed --noconfirm "${PAQUETES[@]}"

# ============================================================================
# 2. CREAR CARPETAS NECESARIAS DEL USUARIO
# ============================================================================
echo "-> Creando directorios de usuario..."
mkdir -p ~/.config ~/.local/bin ~/.cache/matugen ~/.config/btop/themes ~/Pictures/Wallpapers ~/Pictures/Screenshots

# ============================================================================
# 3. ENLAZAR CONFIGURACIONES CON GNU STOW
# ============================================================================
echo "-> Enlazando dotfiles con GNU Stow..."
cd "$(dirname "$0")"
for carpeta in */; do
    carpeta="${carpeta%/}"
    [ -d "$carpeta" ] && [ "$carpeta" != "mako" ] && stow -R "$carpeta"
done

chmod +x ~/.local/bin/*.sh 2>/dev/null || true

# ============================================================================
# 4. ACTIVAR SERVICIOS DEL SISTEMA
# ============================================================================
echo "-> Habilitando Bluetooth..."
sudo systemctl enable --now bluetooth.service 2>/dev/null || true

# ============================================================================
# 5. GENERAR PALETA DE COLORES INICIAL (MATERIAL 3)
# ============================================================================
if [ -f "$HOME/Pictures/Wallpapers/Programming.jpg" ]; then
    matugen image "$HOME/Pictures/Wallpapers/Programming.jpg" -m dark --source-color-index 0 >/dev/null 2>&1 || true
fi

echo "======================================================"
echo "  ¡Instalación completada! Reinicia sesión en Hyprland"
echo "======================================================"
