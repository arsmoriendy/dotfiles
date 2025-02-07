let config_overrides = {
  show_banner: false
  footer_mode: "auto"
}

$env.config = $env.config | merge $config_overrides

# {% if SYSTEM.platform == "Windows" || io::env("WSL_DISTRO_NAME", "null") != "null" %}
#<yolk> $env.config.shell_integration.osc133 = false
# {% end %}

# {% if SYSTEM.platform != "Windows" %}
let ssh_agent_sock_path = ($env.XDG_RUNTIME_DIR | path join ssh-agent)
if not ($ssh_agent_sock_path | path exists) {
  ssh-agent -a $ssh_agent_sock_path | save -f /dev/null
}
# {% end %}

# source conf.d files (initially inherited from fish shell's config)
source ./conf.d/common.nu
source ./conf.d/evars.nu
source ./conf.d/aliases.nu # I prefer abbrs but nushell doesn't have it yet :(
source ./conf.d/vi.nu
source ./conf.d/keybinds.nu
source ./conf.d/zoxide.nu
source ./conf.d/prompt.nu
source ./conf.d/carapace.nu
