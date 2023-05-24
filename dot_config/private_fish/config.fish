#!/usr/bin/fish
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# User specific environment
fish_add_path ~/.local/bin
fish_add_path ~/bin
fish_add_path ~/.cargo/bin

set -x DISTRO (cat /etc/os-release | grep ^ID | cut -d= -f2)

switch $DISTRO
  case fedora
    set -x PACK_MAN "dnf"
    set -x DISTRO_ICON ""
  case arch
    set -x PACK_MAN "pacman --color always"
    set -x DISTRO_ICON ""
  case gentoo
    set -x PACK_MAN "emerge"
    set -x DISTRO_ICON ""
  case ubuntu
    set -x PACK_MAN "apt"
    set -x DISTRO_ICON ""
end

### ABBREVIATIONS ###
abbr -a p "sudo $PACK_MAN"
abbr -a sctl "sudo systemctl"
abbr -a ls "exa --icons"
abbr -a la "exa -alFH --icons"
abbr -a lam "exa -alFH -s modified --time-style long-iso --icons"
abbr -a che "chezmoi"
abbr -a bat "bat --theme gruvbox-dark -f"
abbr -a ip "ip -c=always"
abbr -a snaproot "sudo btrfs subvolume snapshot / /.btrfs-snapshots/@_$(date -Iseconds)"
abbr -a subdel "sudo btrfs subvolume delete"
[ $DISTRO = "fedora" ]; and alias 7z=7za

### PROMPT ###
function fish_prompt
  if [ (fish_git_prompt) ]
    set -f GIT ─"["(set_color --bold cyan)"  "(string sub -s 3 -e -1 (fish_git_prompt))(set_color --bold red)" ]"
  else
    set -f GIT ""
  end

  set -U fish_prompt_pwd_dir_length 0

  set -f LEFT (set_color --bold red)"┌"\[(set_color --bold yellow)(prompt_pwd)(set_color --bold red)\]$GIT
  set -f RIGHT \[(set_color --bold yellow)(whoami)(set_color --bold cyan)@(set_color --bold blue)(hostnamectl | awk -F ": " NR==2'{print $2}')(set_color --bold brcyan)" $DISTRO_ICON "(set_color --bold magenta)(date +%T)(set_color --bold red)\]"┐"

  set -f LINE (set_color --bold red)
  set -f i (math (string length -V $LEFT) + (string length -V $RIGHT))
  while [ $i -lt $COLUMNS ]
    set i (math $i + 1)
    set LINE "$LINE─"
  end

  echo -e "$LEFT$LINE$RIGHT"
  echo -e "└"(fish_default_mode_prompt; set_color --bold red)"─[ "(set_color normal)

end

function fish_right_prompt
  if [ $status -ne 0 ]
    set EXIT (set_color --bold red)""
  else
    set EXIT (set_color --bold green)""
  end

  if [ $CMD_DURATION -gt 3600000 ]
    set PARSED_CMD_DURATION (math -s1 $CMD_DURATION / 3600000)"h"
  else if [ $CMD_DURATION -gt 60000 ]
    set PARSED_CMD_DURATION (math -s1 $CMD_DURATION / 60000)"m"
  else if [ $CMD_DURATION -gt 1000 ]
    set PARSED_CMD_DURATION (math -s1 $CMD_DURATION / 1000)"s"
  else
    set PARSED_CMD_DURATION $CMD_DURATION"ms"
  end

  echo -e (set_color --bold red)"]─[$EXIT $PARSED_CMD_DURATION"(set_color --bold red)"]┘"
  echo -e (set_color normal)
end

### AUTO START TMUX ###
if [ -n $PS1 ]; and [ -z $TMUX ]; and [ ! (string match 'main*(attached)' (tmux ls)) ]; and [ ! (string match '/dev/tty*' (tty) ) ]
  command tmux new-session -A -s main
end

### ENVIRONMENT VARIABLES ###
set -x TERMINAL kitty # used for i3-sensible-terminal
set -x EDITOR nvim
set -x MANPAGER "nvim +Man!"

### GREETING ###
function fish_greeting

  if type -q figlet; and type -q lolcat
    figlet -c -w $COLUMNS (whoami) -f smslant | lolcat -r
    for i in (seq 1 $COLUMNS)
      echo -n ─
    end
  end

  function neo_print -d "Takes 2 args and prints it in centered neofetch format"
    set -f halfcol (math floor $COLUMNS / 2)
    printf (set_color --bold cyan)"%*s"(set_color --bold yellow)"%-*s\n" $halfcol "$argv[1]: " $halfcol " $argv[2]"
  end

  function get_wttr -d "Fetch data from .config/wttr_info"
    cat $HOME/.config/wttr_info | awk -F "|" '{print $'"$argv[1]"'}'
  end

  if [ -e $HOME/.config/wttr_info -a -s $HOME/.config/wttr_info ]
    neo_print "Day, Date" (date "+%A, %B %d %Y")
    neo_print "Time" (date "+%T %p")
    neo_print "Location" (get_wttr 1)
    neo_print "Weather" (get_wttr 2)
    neo_print "Actual Temperature / Feels Like" (get_wttr 3)
    neo_print "Wind" (get_wttr 4)
    neo_print "Moon Day / Phase" (get_wttr 5)
  end

  fish -c 'curl -s "wttr.in?format=%l|%C%c|%t+/+%f|%w|%M%m|%T" 1> $HOME/.config/wttr_info' &
end

# VI bindings
fish_vi_key_bindings
function fish_mode_prompt; end
function fish_default_mode_prompt
  switch $fish_bind_mode
    case default
      echo -ne (set_color --bold red)"[N]"
    case insert
      echo -ne (set_color --bold red)"["(set_color --bold green)I(set_color --bold red)"]"
    case replace_one
      echo -ne (set_color --bold red)"["(set_color --bold green)R(set_color --bold red)"]"
    case visual
      echo -ne (set_color --bold red)"["(set_color --bold brmagenta)V(set_color --bold red)"]"
    case '*'
      echo -ne (set_color --bold red)"[?]"
  end
  set_color normal
end
bind --mode insert \cc 'set fish_bind_mode default; commandline -f repaint'

# auto startx
if [ (tty) = "/dev/tty1" ]
  startx
end
