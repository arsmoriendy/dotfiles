load-env {
  TERMINAL: "wezterm" # used for i3-sensible-terminal
  EDITOR: "nvim"
  MANPAGER: "nvim +Man!"
  # {% if SYSTEM.platform != "Windows" %}
  GOPATH: $"($env.HOME)/.go"
  SSH_AUTH_SOCK: $"($env.XDG_RUNTIME_DIR)/ssh-agent"
  # {% end %}
  VIRTUAL_ENV_DISABLE_PROMPT: true
  PATH: ($env.PATH ++ [
    ("~/.local/bin/" | path expand)
  ])
}
