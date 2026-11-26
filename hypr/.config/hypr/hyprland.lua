-- Carga los colores dinámicos generados por Matugen (con respaldo morado/azul si aún no existen)
local ok, dyn_colors = pcall(dofile, os.getenv("HOME") .. "/.cache/matugen/colors-hyprland.lua")
local active_col1 = ok and dyn_colors.primary or "rgba(cba6f7ee)"
local active_col2 = ok and dyn_colors.secondary or "rgba(89b4faee)"

-- ============================================================================
-- ARCHIVO DE CONFIGURACIÓN DE HYPRLAND (EN LUA)
-- ============================================================================
-- Wiki oficial: https://hypr.land

-- ============================================================================
-- 1. MONITORES (PANTALLAS)
-- ============================================================================
-- Configura resolución, Hz, posición y escala. (Usa "hyprctl monitors" para ver nombres).
hl.monitor({
    output   = "DP-3",            -- Primer puerto/monitor
    mode     = "1920x1080@60",    -- Resolución y tasa de refresco
    position = "auto",            -- Posición automática
    scale    = "auto",            -- Escala automática (1 = 100%)
})

hl.monitor({
    output   = "HDMI-A-1",        -- Segundo puerto/monitor (HDMI)
    mode     = "1920x1080@60",    -- Resolución y tasa de refresco
    position = "auto",            -- Lo coloca al lado automáticamente
    scale    = "auto",            -- Escala automática
})

-- ============================================================================
-- 2. MIS PROGRAMAS (VARIABLES PRINCIPALES)
-- ============================================================================
local terminal    = "kitty"            -- Terminal principal estilizada
local fileManager = "kitty -e yazi"    -- Explorador visual de archivos (o cambia a "dolphin")
local menu        = "rofi -show drun"  -- Lanzador visual de apps estilo Catppuccin

-- ============================================================================
-- 3. AUTOARRANQUE (AUTOSTART)
-- ============================================================================
-- Programas que inician solos con Hyprland (los activaremos al instalar Waybar y fondo):
hl.on("hyprland.start", function ()
hl.exec_cmd("waybar")             -- Barra superior
hl.exec_cmd("aww-daemon")          -- Fondo de pantalla
hl.exec_cmd("nm-applet")          -- Icono de Wi-Fi/Red
hl.exec_cmd("swaync")
hl.exec_cmd("wl-paste --type text --watch cliphist store")  -- Guarda textos copiados
hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Guarda imágenes copiadas
end)

-- ============================================================================
-- 4. VARIABLES DE ENTORNO Y PERMISOS
-- ============================================================================
hl.env("XCURSOR_SIZE", "24")     -- Tamaño del puntero en apps X11/GTK
hl.env("HYPRCURSOR_SIZE", "24")  -- Tamaño del puntero nativo en Wayland

-- Permisos de seguridad (comentados para evitar avisos al capturar pantalla):
-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- ============================================================================
-- 5. APARIENCIA Y DISEÑO (LOOK AND FEEL)
-- ============================================================================
hl.config({
    general = {
        gaps_in  = 6,             -- Espacio en píxeles ENTRE ventanas
        gaps_out = 16,            -- Espacio entre ventanas y BORDES del monitor
        border_size = 2,          -- Grosor del borde alrededor de ventanas
        col = {
         -- Borde activo dinámico que cambia según tu fondo de pantalla
         active_border   = { colors = {active_col1, active_col2}, angle = 45 },
         inactive_border = "rgba(45475aaa)",
     },
        resize_on_border = true,  -- Permite redimensionar arrastrando bordes con el mouse
        allow_tearing    = false, -- Evita cortes visuales (V-Sync activado)
        layout           = "dwindle", -- Mosaico en espiral/árbol binario
    },

    decoration = {
        rounding       = 14,      -- Esquinas redondeadas (14px estilo Material Design)
        rounding_power = 2,       -- Suavidad de curva de esquinas
        active_opacity   = 1.0,   -- Opacidad ventana activa (100%)
        inactive_opacity = 0.95,  -- Ligera transparencia (95%) en ventanas inactivas

        shadow = {
            enabled      = true,       -- Sombra debajo de ventanas
            range        = 12,         -- Alcance de sombra
            render_power = 3,          -- Intensidad de sombra
            color        = 0x6611111b, -- Color oscuro suave Catppuccin
        },

        blur = {
            enabled   = true,     -- Desenfoque tipo vidrio borroso detrás de Kitty y Rofi
            size      = 5,        -- Intensidad de desenfoque
            passes    = 2,        -- Pasadas de suavizado
            vibrancy  = 0.1696,   -- Realce de color tras el cristal
        },
    },

    animations = { enabled = true }, -- Activa animaciones fluidas
})

-- -- ============================================================================
-- 6. ANIMACIONES (ESTILO MATERIAL 3 EXPRESSIVE)
-- ============================================================================
hl.config({
    animations = {
        enabled = true,
        bezier = {
            "giro, 0.45, 0.05, 0.15, 1.15",
            "expressive, 0.38, 1.21, 0.22, 1.00",
            "standard,   0.05, 0.90, 0.10, 1.05",
            "decel,      0.00, 0.00, 0.20, 1.00",
        },
        animation = {
            "windowsIn,    1, 5, expressive, popin 80%",
            "windowsOut,   1, 4, decel,      popin 80%",
            "windowsMove,  1, 5, standard,   slide",
            "border,       1, 8, standard",
            "borderangle,  1, 40, standard,  loop",
            "fadeIn,       1, 4, standard",
            "fadeOut,      1, 4, decel",
            "workspaces,   1, 4, standard, slide",
        },
    },
})

-- ============================================================================
-- 7. CONFIGURACIÓN DE LAYOUTS (MOSAICO)
-- ============================================================================
hl.config({ dwindle   = { preserve_split = true } }) -- Mantiene división al cerrar ventanas
hl.config({ master    = { new_status = "master" } }) -- Ventana nueva toma posición principal
hl.config({ scrolling = { fullscreen_on_one_column = true } }) -- Pantalla completa si hay 1 columna

-- ============================================================================
-- 8. MISCELÁNEOS Y CAPAS FLOTANTES
-- ============================================================================
hl.config({
    misc = {
        force_default_wallpaper = 0,    -- 0 = Quita fondo anime por defecto (-1 para activarlo)
        disable_hyprland_logo   = true, -- Oculta logo de Hyprland en el fondo
        disable_splash_rendering = true, -- Quita las frases aleatorias de abajo
    },
    layers = {
        allow_new_top_layers_over_existing_fullscreen = true, -- Permite abrir Rofi sobre pantalla completa
    },
})

-- ============================================================================
-- 9. TECLADO, MOUSE Y TOUCHPAD (INPUT)
-- ============================================================================
hl.config({
    input = {
        kb_layout  = "us",     -- Distribución teclado (usa "latam" o "es" si tienes Ñ física)
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        follow_mouse = 1,      -- El foco sigue al puntero del mouse
        sensitivity  = 0,      -- Velocidad mouse (-1.0 a 1.0; 0 = nativa)
        touchpad = {
            natural_scroll = false, -- Cambia a true para desplazamiento invertido
        },
    },
})

-- Gesto táctil en touchpad: 3 dedos horizontal cambia de escritorio
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Configuración de dispositivo específico (opcional)
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- ============================================================================
-- 10. ATAJOS DE TECLADO Y MOUSE (KEYBINDINGS)
-- ============================================================================
local mainMod = "SUPER" -- Tecla Windows/Command como tecla principal

-- Apertura y control de programas
hl.bind(mainMod .. " + Q",     hl.dsp.exec_cmd(terminal))       -- SUPER + Q: Abre Kitty
hl.bind(mainMod .. " + C",     hl.dsp.window.close())           -- SUPER + C: Cierra ventana activa
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd(fileManager))    -- SUPER + E: Abre archivos (Yazi)
hl.bind(mainMod .. " + R",     hl.dsp.exec_cmd(menu))           -- SUPER + R: Abre lanzador (Rofi)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))           -- SUPER + ESPACIO: Abre Rofi
hl.bind(mainMod .. " + F",     hl.dsp.window.float({ action = "toggle" })) -- SUPER + F: Flotante/Mosaico
hl.bind(mainMod .. " + P",     hl.dsp.window.pseudo())          -- SUPER + P: Tamaño fijo en mosaico
hl.bind(mainMod .. " + J",     hl.dsp.layout("togglesplit"))    -- SUPER + J: Rotar división horizontal/vertical
hl.bind(mainMod .. " + M",     hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")) -- SUPER + M: Salir de Hyprland

-- Mover el foco entre ventanas con SUPER + Flechas
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))  -- Izquierda
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" })) -- Derecha
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))    -- Arriba
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))  -- Abajo

-- Cambiar y mover ventanas entre escritorios (Workspaces 1 al 10)
for i = 1, 10 do
    local key = i % 10 -- El 10 corresponde a la tecla 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))       -- SUPER + [1-0]: Ir a escritorio
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i })) -- SUPER + SHIFT + [1-0]: Mover ventana
end

-- --- CAPTURAS DE PANTALLA ---
-- SUPER + SHIFT + X: Recortar un área (ignora pulsaciones repetidas si slurp ya está activo)
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("pgrep -x slurp >/dev/null || grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/captura_$(date +%Y%m%d_%H%M%S).png | wl-copy"))

-- Print: Captura toda la pantalla
hl.bind("Print", hl.dsp.exec_cmd("grim - | tee ~/Pictures/Screenshots/captura_$(date +%Y%m%d_%H%M%S).png | wl-copy"))

-- Escritorio especial oculto (Scratchpad)
hl.bind(mainMod .. " + Z",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.window.move({ workspace = "special:magic" }))

-- Cambiar escritorio con rueda del mouse + SUPER
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" })) -- Siguiente escritorio
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" })) -- Escritorio anterior

-- Mover y redimensionar ventanas arrastrando con SUPER + Clic Izquierdo/Derecho
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Teclas multimedia y brillo (Laptops / Teclados con Fn)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true }) -- Subir volumen
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true }) -- Bajar volumen
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true }) -- Silenciar audio
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true }) -- Silenciar micrófono
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true }) -- Subir brillo
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true }) -- Bajar brillo

-- Controles de música (Requiere playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true }) -- Siguiente
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- Pausar/Reanudar
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- Play/Pause
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true }) -- Anterior

-- Abrir historial de portapapeles con SUPER + ALT + V
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("sh -c 'cliphist list | rofi -dmenu -p \"Portapapeles:\" | cliphist decode | wl-copy'"))

-- SUPER + L: Bloquea la pantalla al instante con Hyprlock
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- SUPER + W: Abre el selector visual de fondos y cambia los colores del escritorio
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/cambiar-fondo.sh"))

-- SUPER + / (slash): Abre la chuleta visual de atajos en Rofi
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/atajos.sh"))

-- Variable para recordar si el panel lateral está abierto o cerrado
local panel_abierto = false

-- SUPER + N: Abre o cierra el Centro de Control flotante (SwayNC)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))


-- ============================================================================
-- 11. REGLAS DE VENTANAS (WINDOW RULES)
-- ============================================================================
-- Evita que las apps pidan maximizarse solas rompiendo el mosaico
local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Soluciona enfoque de ventanas fantasma en apps XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Posiciona la ventana de ejecución rápida de Hyprland si se llega a usar
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Efecto cristal desenfocado (blur) para el Centro de Control SwayNC
hl.layer_rule({
    name  = "swaync-blur",
    match = { namespace = "swaync-control-center" },
    blur  = true,
    ignore_alpha = 0.5,
})


-- Regla para anclar el Reloj Gigante (Conky) al fondo de pantalla
hl.window_rule({
    name             = "reloj-conky",
    match            = { class = "ConkyClock" },
    float            = true,
    pin              = true,
    no_focus         = true,
    no_initial_focus = true,
    no_shadow        = true,
    no_anim          = true,
    border_size      = 0,
    opacity          = 0.90,
})

-- SUPER + T: Muestra u oculta el reloj gigante del escritorio al instante
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("pgrep -x conky >/dev/null && killall conky || LC_TIME=es_MX.UTF-8 conky -d"))
