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
    },
    sioyek: #{
      targets: switch SYSTEM.platform {
        "Windows" => "C:/ProgramData/sioyek",
        _ =>  "~/.config/sioyek"
      },
    },
    git: #{
      targets: "~/",
      main_file: ".gitconfig",
      strategy: "merge",
    },
};
