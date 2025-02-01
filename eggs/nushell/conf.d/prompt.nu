# starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

load-env {
  PROMPT_INDICATOR_VI_NORMAL: $"(ansi purple_bold)N(ansi red_bold) ]─[ "
  PROMPT_INDICATOR_VI_INSERT: $"(ansi cyan_bold)I(ansi red_bold) ]─[ "
}
