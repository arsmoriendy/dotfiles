#!/usr/bin/env nu

def main [github_token: string] {
  let auth_header = $"Authorization: Bearer ($github_token)"
  let list_url = "https://api.github.com/repos/mason-org/mason-registry/contents/packages"
  let list = curl --silent -H $auth_header $list_url | from json | get name

  def pkg_url [p: string] {
    $"https://raw.githubusercontent.com/mason-org/mason-registry/main/packages/($p)/package.yaml"
  }

  def get_github_stars [source: record] {
    if ($source | get id | str contains "pkg:github") {
      let repo_path = ($source.id | str replace "pkg:github/" "" | str replace --regex "@.*" "")
      let api_url = $"https://api.github.com/repos/($repo_path)"
      let res = curl --silent -H $auth_header $api_url | from json
      $res | get --optional  stargazers_count
    }
  }

  let list = $list | par-each {|package| curl --silent (pkg_url $package) | from yaml}

  # filter lsps only
  let list = $list | where categories has "LSP"

  # add github stars for packages sourced from github
  let list = $list | par-each {|pkg|
    let stars = if ($pkg.source | is-not-empty) {
      get_github_stars $pkg.source
    }
    $pkg | merge {github_stars: $stars}
  }

  $list | to json | save tmp

  cp tmp lsp-registry.json
  rm tmp
}
