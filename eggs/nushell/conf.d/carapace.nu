load-env {
  CARAPACE_BRIDGES: 'fish,bash,zsh'
  CARAPACE_LOG: 0
  CARAPACE_MATCH: 1
}

carapace _carapace nushell | save --force ($autoload_dir | path join "carapace.nu")
