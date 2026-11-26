#!/usr/bin/env bash
# Chuleta interactiva de atajos de Hyprland, Kitty y Neovim en Rofi

ATAJOS="    SUPER + Q              ➔  Abrir terminal (Kitty)
    SUPER + SPACE / R      ➔  Abrir lanzador de aplicaciones (Rofi)
    SUPER + W              ➔  Cambiar fondo de pantalla y colores (Material 3)
    SUPER + E              ➔  Abrir explorador de archivos (Yazi)
    SUPER + C              ➔  Cerrar ventana activa
    SUPER + F              ➔  Alternar ventana flotante / mosaico
    SUPER + V              ➔  Abrir historial del portapapeles
    SUPER + L              ➔  Bloquear pantalla (Hyprlock)
    SUPER + SHIFT + X      ➔  Recortar captura de pantalla (Área)
    Print                  ➔  Capturar toda la pantalla
    SUPER + [1-0]          ➔  Cambiar de escritorio (Workspace)
    SUPER + SHIFT + [1-0]  ➔  Mover ventana a otro escritorio
    SUPER + Flechas        ➔  Mover foco entre ventanas
    SUPER + Clic Izq/Der   ➔  Mover o redimensionar ventana con mouse
    SUPER + /              ➔  Mostrar esta chuleta de atajos
  [Kitty] Ctrl+Shift+E   ➔  Abrir carpetas visuales (Yazi)
  [Kitty] Ctrl+Shift+T/W ➔  Nueva pestaña / Cerrar pestaña
  [Nvim]  Espacio + e    ➔  Abrir/Cerrar árbol de carpetas
  [Nvim]  Espacio + ff   ➔  Buscar archivos en proyecto (Telescope)
  [Nvim]  Espacio + fg   ➔  Buscar texto en archivos
  [Nvim]  K / gd         ➔  Ver documentación / Ir a definición (LSP)"

echo -e "$ATAJOS" | rofi -dmenu -i -p "Atajos:" -theme-str 'window { width: 680px; } listview { lines: 14; }'
