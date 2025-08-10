# Sway Configuration

This directory configures `sway` — the wayland window manager.

## Setting up required system variables

Make sure the following required sway system variables are set accordingly:

| Variable Name     | Description                                                                                                       |
| ----------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| `$ewwouput`       | Prefered output for [eww](../eww), run `swaymsg -t get_outputs                                                    | jq '.[].model'` to list available outputs |
| `$polkitgnomexec` | On arch `/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1`, on nix `polkit-gnome-authentication-agent-1` |

> [!NOTE]
> Copy `./system-specific/vars.swayconfig.example` to `./system-specific/vars.swayconfig` as an initial template.
