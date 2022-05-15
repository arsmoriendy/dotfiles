### DETERMINE PACKAGE MANAGER ###
declare -A osInfo;
osInfo[/etc/fedora-release]=dnf
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        PACK_MAN=${osInfo[$f]}
    fi
done

### ALIAS ###
alias p="sudo ${PACK_MAN}"
alias la='ls -AlhF'

### GIT AUTO COMPLETE AND PROMPT###
. ~/.config/git-completion.bash
. ~/.config/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

### PROMPT ###
PROMPT_COMMAND=__prompt_command
__prompt_command() {
  local EXIT="$?"

  PS1='┎\[\e[34m\][\w] \[\e[33m\]$(__git_ps1 "[%s] ")\[\e[35m\][\T]\[\e[0m\]'
  PS1+='\n┖'

  if [ $EXIT != 0 ]; then
    PS1+='\[\e[1;31m\]'
  else
    PS1+='\[\e[1;32m\]'
  fi

  PS1+='>>> \[\e[0m\]'
}

### AUTO START TMUX ###
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ "$TERM" =~ alacritty ]]; then
  exec tmux
fi

### ENVIRONMENT VARIABLES ###
export EDITOR=nvim
