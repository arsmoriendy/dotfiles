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
    eww: #{
      targets: "~/.config/eww/",
      main_file: "eww.yuck",
    },
    lazygit: #{
      targets: "~/.config/lazygit",
      main_file: "config.yml",
    },
    nvim: #{
      targets: "~/.config/nvim",
      main_file: "init.lua",
    },
    starship: #{
      targets: "~/.config",
      strategy: "merge",
      main_file: "starship.toml",
    },
    zathura: #{
      targets: "~/.config/zathura",
      main_file: "zathurarc",
    },
    mpv: #{
      targets: "~/.config/mpv",
      main_file: "mpv.conf",
    },
};
