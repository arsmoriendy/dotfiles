$env.config.show_banner = false;

$env.config.edit_mode = "vi";
$env.config.cursor_shape.vi_insert = "line";
$env.config.cursor_shape.vi_normal = "block";

$env.config.footer_mode = "auto";

# source conf.d files (initially inherited from fish shell's config)
source ./conf.d/evars.nu
source ./conf.d/aliases.nu # I prefer abbrs but nushell doesn't have it yet :(
source ./conf.d/zoxide.nu
