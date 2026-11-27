# Dotfiles — Arch Linux + Hyprland (Material 3)

Entorno en **Arch Linux** con **Hyprland** en Lua, colores dinámicos **Material Design 3** (`matugen`) y **GNU Stow**.

## Características
- **5 Escritorios por Actividad:** Programar, Navegar, Jugar, Música y Varios con cambio de fondo por monitor (`DP-3` y `HDMI-A-1`).
- **Paleta Dinámica (`matugen`):** Sincronizada en Kitty, Waybar, Rofi, SwayNC, Hyprlock, `btop` y Spotify (`Spicetify`).
- **Multimedia & Gaming:** Spotify en vivo en Waybar (`mpris`), panel flotante `btop` al hacer clic en CPU/RAM y reglas maximizadas para Tibia y Steam.
- **Desarrollo:** Neovim (`init.lua`) con LSP, autocompletado, Telescope y guías de indentación.

## Atajos de Teclado (Shortcuts)

### Hyprland (Escritorio y Ventanas)
- **Super + Q**: Abrir terminal (Kitty)
- **Super + Espacio / R**: Lanzador de aplicaciones (Rofi)
- **Super + E**: Explorador de archivos (Yazi)
- **Super + C**: Cerrar ventana activa
- **Super + F**: Alternar ventana flotante / mosaico
- **Super + P / J**: Modo pseudo / Rotar división de ventanas
- **Super + W**: Galería visual de wallpapers y tema Material 3
- **Super + N**: Centro de Control, Clima y Horas Mundiales (SwayNC)
- **Super + T**: Mostrar/Ocultar reloj gigante en escritorio (Conky)
- **Super + V**: Historial del portapapeles (Cliphist)
- **Super + L**: Bloquear pantalla (Hyprlock)
- **Super + /**: Chuleta rápida de atajos en pantalla
- **Super + Shift + X**: Captura de pantalla por área (recorte)
- **Print**: Captura de pantalla completa
- **Super + [1-5]**: Cambiar de escritorio (Programar, Navegar, Jugar, Música, Varios)
- **Super + Shift + [1-5]**: Mover ventana al escritorio indicado
- **Super + Z / Shift + Z**: Alternar o enviar ventana al escritorio oculto (Scratchpad)
- **Super + Flechas**: Mover foco entre ventanas
- **Super + Clic Izq / Der**: Arrastrar o redimensionar ventana flotante

### Terminal (Kitty) y Editor (Neovim)
- **Ctrl + Shift + E** *(Kitty)*: Abrir explorador Yazi en ventana nueva
- **Ctrl + Shift + T / W** *(Kitty)*: Nueva pestaña / Cerrar pestaña
- **Ctrl + Shift + F5** *(Kitty)*: Recargar configuración al instante
- **Espacio + e** *(Neovim)*: Abrir/Cerrar árbol de carpetas (Neo-tree)
- **Espacio + ff / fg** *(Neovim)*: Buscar archivos / Buscar texto (Telescope)
- **Ctrl + S** *(Neovim)*: Guardar archivo actual
- **gd / K** *(Neovim)*: Ir a definición / Ver documentación (LSP)

## Instalación Rápida
- Clona el repositorio en `~/dotfiles` y ejecuta `./install.sh` para instalar paquetes y enlazar todo con GNU Stow.
