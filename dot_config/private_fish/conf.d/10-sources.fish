# load system specific confgs
for CONFIG in (find "$(realpath ~/.config/fish/conf.d/sysconfig)" -type f -name "*.fish")
  source "$CONFIG"
end
