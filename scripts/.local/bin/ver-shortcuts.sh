#!/usr/bin/env bash
# Lista limpia y directa de tus shortcuts principales

SHORTCUTS="  Super + Q              │  Abrir terminal Kitty
  Super + C              │  Cerrar ventana activa
  Super + Espacio        │  Buscador de aplicaciones
  Super + E              │  Explorador de archivos
  Super + N              │  Centro de Control y Clima
  Super + W              │  Galería de wallpapers
  Super + V              │  Historial de portapapeles
  Super + L              │  Bloquear pantalla
  Super + /              │  Ver shortcuts
  Super + 1 - 5          │  Cambiar de escritorio
  Super + Shift + 1 - 5  │  Mover ventana a escritorio
  Super + Shift + X      │  Captura de pantalla por área
  Print                  │  Captura de pantalla completa
  Super + F              │  Pantalla completa
  Super + M              │  Salir de Hyprland
  Super + Flechas        │  Mover foco entre ventanas
  Super + Clic Izq       │  Arrastrar ventana flotante
  Super + Clic Der       │  Redimensionar ventana"

echo -e "$SHORTCUTS" | rofi -dmenu -i -p " " -theme-str '
window { width: 620px; border-radius: 24px; padding: 18px; }
entry { placeholder: "Buscar shortcut..."; }
listview { lines: 12; spacing: 6px; }
element { children: [ element-text ]; padding: 9px 14px; }
'
