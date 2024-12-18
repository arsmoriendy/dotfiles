# Terminfo

If the wezterm termminfo file is not included by the package manager, download it manually using the following command.

> [!note]
> The following section is derived from:
> https://wezfurlong.org/wezterm/config/lua/config/term.html
> Consult the above link for further debugging

```bash
tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
  && rm $tempfile
```
