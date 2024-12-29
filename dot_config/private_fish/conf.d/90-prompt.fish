# # DEPENDENCIES
# - whoami
# - date

function fish_prompt
  if [ (fish_git_prompt) ]
    set -f GIT ─"["(set_color --bold cyan)"  "(string sub -s 3 -e -1 (fish_git_prompt))(set_color --bold red)" ]"
  else
    set -f GIT ""
  end

  set -g fish_prompt_pwd_dir_length 0

  function __VENV_PROMPT__
    if test -z "$VIRTUAL_ENV"
      echo && return
    end

    set -f ENV_NAME (echo "$VIRTUAL_ENV" | awk -F / '{print $NF}')
    echo "─["(set_color --bold blue)"  $ENV_NAME"(set_color --bold red)" ]"
  end

  function __NIX_SHELL_PROMPT__
    if echo "$PATH" | grep -qc "nix/store"
      echo "─["(set_color --bold cyan)" 󱄅 shell"(set_color --bold red)" ]"
      return
    end
    echo && return
  end

  set -f LEFT (set_color --bold red)"┌"\[(set_color --bold yellow)(prompt_pwd)(set_color --bold red)\]$GIT(__VENV_PROMPT__)(__NIX_SHELL_PROMPT__)
  set -f RIGHT \[(set_color --bold yellow)(whoami)(set_color --bold cyan)@(set_color --bold blue)(prompt_hostname)(set_color --bold brcyan)" $DISTRO_ICON "(set_color --bold magenta)(date +%T)(set_color --bold red)\]"┐"

  set -f LINE (set_color --bold red)
  set -f i (math (string length -V $LEFT) + (string length -V $RIGHT))
  while [ $i -lt $COLUMNS ]
    set i (math $i + 1)
    set LINE "$LINE─"
  end

  echo -e "$LEFT$LINE$RIGHT"
  echo -e "└"(fish_custom_mode_prompt; set_color --bold red)"─[ "(set_color normal)

  functions -e __VENV_PROMPT__
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

