#!/usr/bin/env nu

let list_url = "https://api.github.com/repos/mason-org/mason-registry/contents/packages"
let list = curl $list_url | from json | get name

def pkg_url [p: string] {
  $"https://raw.githubusercontent.com/mason-org/mason-registry/main/packages/($p)/package.yaml"
}

$list | each {|package| curl (pkg_url $package) | from yaml} | to json | save tmp

cp tmp mason-registry.json
rm tmp
