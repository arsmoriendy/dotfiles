# starship prompt
starship init nu | save -f ($autoload_dir | path join "starship.nu")

load-env {
  PROMPT_INDICATOR_VI_NORMAL: $"(ansi --escape 1m)(ansi light_purple)N(ansi light_red) ]─[ (ansi reset)"
  PROMPT_INDICATOR_VI_INSERT: $"(ansi --escape 1m)(ansi light_cyan)I(ansi light_red) ]─[ (ansi reset)"
}
