$env.config.keybindings ++= [
  { # match fish's alt+e keybind to open editor
    name: open_editor
    modifier: alt
    keycode: char_e
    mode: [emacs, vi_insert, vi_normal]
    event: {send: OpenEditor }
  }
]
