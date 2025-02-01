$env.config.show_banner = false;
$env.config.footer_mode = "auto";
$env.config.footer_mode = "auto";

# {% if SYSTEM.platform == "Windows" %}
#<yolk> $env.config.shell_integration.osc133 = false
# {% end %}

# source conf.d files (initially inherited from fish shell's config)
source ./conf.d/evars.nu
source ./conf.d/aliases.nu # I prefer abbrs but nushell doesn't have it yet :(
source ./conf.d/vi.nu
source ./conf.d/keybinds.nu
source ./conf.d/zoxide.nu
source ./conf.d/prompt.nu
source ./conf.d/carapace.nu

# source sysconfig
source ./conf.d/sysconfig.nu
