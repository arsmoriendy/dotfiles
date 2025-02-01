export let data = #{
    for_vcs: LOCAL,
    cool_setting: if SYSTEM.hostname == "foo" { 10 } else { 25 }
};
export let eggs = #{
    nushell: #{
      targets: "~/.config/nushell/",
      enabled: true,
      main_file: "config.nu"
    }
};
