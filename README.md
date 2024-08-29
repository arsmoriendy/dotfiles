# gruv0
Gruvbox themed rice

> [!IMPORTANT]
> For everything to work, some system specific configs needed to be set:
> - [sway config](./dot_config/sway/README.md)
> - [eww config](./dot_config/eww/README.md)

## Dependencies
### Arch/Pacman:
#### Runtime Dependencies
- sway (^1.9)
- pulseaudio (^17.0-3)
- waybar (^0.10.0)
- eww (^0.5.0)
- polkit-gnome
- wl-clipboard (^2.2.1)
- ttf-cascadia-code-nerd
- grim - screenshot utility
- slurp - region selector for grim
- swaylock
##### Optional dependencies:
- swaybg (^1.2.0)
- brightnessctl (^0.5.0) - for devices that need brightness control
#### Compile/Config Time Dependencies
Only needed for configuration
- dart-sass (^1.70.0) - waybar, eww gtk css styling
- wev (1.0.0-13) - sway keybinds
