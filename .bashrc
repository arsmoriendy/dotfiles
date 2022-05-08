### ALIAS ###
alias p='sudo apt'
alias e='explorer.exe'
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
