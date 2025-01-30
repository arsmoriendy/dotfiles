$env.config.show_banner = false;
$env.config.footer_mode = "auto";

# source conf.d files (initially inherited from fish shell's config)
source ./conf.d/evars.nu
source ./conf.d/aliases.nu # I prefer abbrs but nushell doesn't have it yet :(
source ./conf.d/vi.nu
source ./conf.d/zoxide.nu
