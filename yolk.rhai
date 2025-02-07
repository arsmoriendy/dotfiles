export let data = #{
    for_vcs: LOCAL,
    cool_setting: if SYSTEM.hostname == "foo" { 10 } else { 25 }
};
export let eggs = #{
    nushell: #{
      targets: switch SYSTEM.platform {
        "Windows" => "~/AppData/Roaming/nushell/",
        _ => "~/.config/nushell/"
      },
      main_file: "config.nu",
      templates: [ "conf.d/evars.nu", "config.nu" ]
    },
    wezterm: #{
      targets: "~/.config/wezterm/",
      main_file: "wezterm.lua",
      templates: [ "wezterm.lua" ]
    }
};
