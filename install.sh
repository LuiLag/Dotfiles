#!/usr/bin/env bash
set -e

echo "======================================================"
echo "  Instalador Automático - Dotfiles Arch + Hyprland"
echo "======================================================"

# 1. Lista de paquetes oficiales necesarios
PAQUETES=(
    hyprland hyprlock hypridle hyprpicker hyprsunset
    waybar swaync rofi-wayland kitty neovim conky
    matugen awww cliphist wl-clipboard grim slurp
    playerctl curl socat jq usbutils bluez bluez-utils
    ttf-jetbrains-mono-nerd papirus-icon-theme stow
)

echo "-> Instalando paquetes base con pacman..."
sudo pacman -S --needed --noconfirm "${PAQUETES[@]}"

# 2. Crear carpetas necesarias del usuario
echo "-> Creando directorios de usuario..."
mkdir -p ~/.config ~/.local/bin ~/.cache/matugen ~/Pictures/Wallpapers ~/Pictures/Screenshots

# 3. Enlazar configuraciones con GNU Stow
echo "-> Enlazando dotfiles con GNU Stow..."
cd "$(dirname "$0")"
for carpeta in */; do
    carpeta="${carpeta%/}"
    [ -d "$carpeta" ] && stow -R "$carpeta"
done

chmod +x ~/.local/bin/*.sh 2>/dev/null || true

# 4. Activar servicios del sistema
echo "-> Habilitando Bluetooth..."
sudo systemctl enable --now bluetooth.service 2>/dev/null || true

# 5. Generar paleta de colores inicial
if [ -f "$HOME/Pictures/Wallpapers/Programming.jpg" ]; then
    matugen image "$HOME/Pictures/Wallpapers/Programming.jpg" -m dark --source-color-index 0 >/dev/null 2>&1 || true
fi

echo "======================================================"
echo "  ¡Instalación completada! Reinicia sesión en Hyprland"
echo "======================================================"
