load-env {
  TERMINAL: "wezterm" # used for i3-sensible-terminal
  EDITOR: "nvim"
  MANPAGER: "nvim +Man!"
  # {% if SYSTEM.platform != "Windows" %}
  GOPATH: $"($env.HOME)/.go"
  SSH_AUTH_SOCK: $"($env.XDG_RUNTIME_DIR)/ssh-agent"
  GPG_TTY: (tty)
  # {% end %}
  VIRTUAL_ENV_DISABLE_PROMPT: true
  PNPM_HOME : ("~/.local/share/pnpm" | path expand)
  PATH: ($env.PATH | append [
    ("~/.local/bin/" | path expand)
    ("~/.cargo/bin/" | path expand)
    ("~/.local/share/pnpm" | path expand)
  ] | uniq)
  QT_QPA_PLATFORMTHEME: "gtk3"
}
