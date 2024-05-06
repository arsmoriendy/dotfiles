# VI bindings

fish_vi_key_bindings # enable vi bindings

# Disable default vi indicator.
# The default vi indicator doesn't allow custom positions.
function fish_mode_prompt; end

# User made custom vi indicator function.
# Allows for versitile positioning vi indicator.
function fish_custom_mode_prompt
  switch $fish_bind_mode # built in fish variable to indicate vi mode
    case default
      echo -ne (set_color --bold red)"[N]"
    case insert
      echo -ne (set_color --bold red)"["(set_color --bold green)I(set_color --bold red)"]"
    case replace_one
      echo -ne (set_color --bold red)"["(set_color --bold green)R(set_color --bold red)"]"
    case visual
      echo -ne (set_color --bold red)"["(set_color --bold brmagenta)V(set_color --bold red)"]"
    case '*'
      echo -ne (set_color --bold red)"[?]"
  end
  set_color normal
end

# Bind <C-c> to go back to normal mode in insert mode
bind --mode insert \cc 'set fish_bind_mode default; commandline -f repaint'
