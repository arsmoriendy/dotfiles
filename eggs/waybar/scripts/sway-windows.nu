#!/usr/bin/env nu
~/.config/waybar/scripts/sway-windows/sway-windows.nu | from json | each {|n| let i = $n.app_id | default "?" | str substring 0..0; if $n.focused {$"[($i)]"} else {$" ($i) "}} | str join " | "
