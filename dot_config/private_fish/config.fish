#!/usr/bin/fish
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# User specific environment
fish_add_path ~/.local/bin
fish_add_path ~/bin

set -xU DISTRO (cat /etc/os-release | grep ^ID | cut -d= -f2)

switch $DISTRO
  case fedora
    set -xU PACK_MAN "dnf"
    set -xU DISTRO_ICON ""
  case arch
    set -xU PACK_MAN "pacman --color always"
    set -xU DISTRO_ICON ""
  case gentoo
    set -xU PACK_MAN "emerge"
    set -xU DISTRO_ICON ""
  case ubuntu
    set -xU PACK_MAN "apt"
    set -xU DISTRO_ICON ""
end

### ALIAS ###
source ~/.alias
[ $DISTRO = "fedora" ]; and alias 7z=7za

### PROMPT ###
function fish_prompt
  if [ $status -ne 0 ]
    set EXIT (set_color -o red)
  else
    set EXIT (set_color -o green)
  end

  if [ (fish_git_prompt) ]
    set -f GIT ─"["(set_color -o cyan)"  "(string sub -s 3 -e -1 (fish_git_prompt))(set_color -o red)"]"
  else
    set -f GIT ""
  end

  set -U fish_prompt_pwd_dir_length 0

  set -f LEFT (set_color -o red)"┌"\[(set_color -o yellow)(prompt_pwd)(set_color -o red)\]$GIT
  set -f RIGHT \[(set_color -o yellow)(whoami)(set_color -o cyan)@(set_color -o blue)(hostname)(set_color -o brcyan)" $DISTRO_ICON "(set_color -o magenta)(date +%T)(set_color -o red)\]"┐"

  set -f LINE (set_color -o red)
  set -f i (math (string length -V $LEFT) + (string length -V $RIGHT))
  while [ $i -lt $COLUMNS ]
    set -f i (math $i + 1)
    set -f LINE "$LINE─"
  end

  echo -e "$LEFT$LINE$RIGHT"

  echo -e "└$EXIT>>> "
end

function fish_right_prompt
  if [ $status -ne 0 ]
    set -f EXIT (set_color -o red)""
  else
    set -f EXIT (set_color -o green)""
  end

  echo -e (set_color -o red)"[$EXIT $CMD_DURATION"(set_color -o red)"]┘"
end

### AUTO START TMUX ###
if [ -n $PS1 ]; and [ -z $TMUX ]; and [ ! (string match 'main*(attached)' (tmux ls)) ]
  command tmux new-session -A -s main
end

### ENVIRONMENT VARIABLES ###
[ (string match -r "kitty" $TERM) ]; and set -xU TERM xterm-256color
set -xU EDITOR nvim

### GREETING ###
function fish_greeting

  if type -q figlet; and type -q lolcat
    figlet -c -w $COLUMNS (whoami) -f THIS | lolcat -r
    for i in (seq 1 $COLUMNS)
      echo -n ─
    end
  end

  fish -c 'curl -s "wttr.in?format=%l|%C%c|%t+/+%f|%w|%M%m|%T" > $HOME/.config/wttr_info' &

  while [ -e (cat $HOME/.config/wttr_info) ]
    sleep 0.5
  end

  function neo_print -d "Takes 2 args and prints it in centered neofetch format"
    set -f halfcol (math floor $COLUMNS / 2)
    printf (set_color -o cyan)"%*s"(set_color -o yellow)"%-*s\n" $halfcol "$argv[1]: " $halfcol " $argv[2]"
  end

  function get_wttr -d "Fetch data from .config/wttr_info"
    cat $HOME/.config/wttr_info | awk -F "|" '{print $'"$argv[1]"'}'
  end

  neo_print "Day, Date" (date "+%A, %B %d %Y")
  neo_print "Time" (date "+%T %p")
  neo_print "Location" (get_wttr 1)
  neo_print "Weather" (get_wttr 2)
  neo_print "Actual Temperature / Feels Like" (get_wttr 3)
  neo_print "Wind" (get_wttr 4)
  neo_print "Moon Day / Phase" (get_wttr 5)
end
