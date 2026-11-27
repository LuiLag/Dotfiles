# ============================================================================
# ARCHIVO DE CONFIGURACIÓN DE BASH (~/.bashrc)
# ============================================================================

# Si la sesión no es interactiva, no hacer nada
[[ $- != *i* ]] && return

# ============================================================================
# 1. ALIAS Y LISTADO VISUAL (EZA)
# ============================================================================
alias ls="eza --icons --group-directories-first"
alias tree="eza --tree --icons"
alias grep="grep --color=auto"
alias ff="nohup firefox-developer-edition >/dev/null 2>&1 & exit"

# ============================================================================
# 2. FUNCIONES PERSONALIZADAS
# ============================================================================
# Lanza una aplicación independiente en segundo plano y cierra la terminal
run() {
    nohup "$@" >/dev/null 2>&1 &
    sleep 0.2
    exit
}

# ============================================================================
# 3. INTERFAZ DE TERMINAL (STARSHIP Y FASTFETCH)
# ============================================================================
eval "$(starship init bash)"
fastfetch
alias dotpush="cd ~/dotfiles && git add -A && git commit -m \"dotfiles: actualizar configuracion\" && git push"
