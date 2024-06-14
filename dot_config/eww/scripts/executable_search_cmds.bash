#!/usr/bin/env bash

main() {
  RECORDS=10
  CMDS=$(get_cmds | grep -m "$RECORDS" -i "$1")
  RECS=""

  for CMD in $CMDS; do
    RECS="$RECS$(encapsulate_cmd $CMD)"
  done

  echo "(box :orientation 'v' $RECS)"
}

get_cmds() {
  local CMDS=""
  local IFS=":"
  for P in "$PATH"; do
    local CMDS="$CMDS\n$(ls --format=single-column $P 2>/dev/null)"
  done
  local CMDS=$(echo "$CMDS" | sort | uniq)
  echo "$CMDS"
}

encapsulate_cmd() {
  echo "(button :onclick \"$1\" (label :text \"$1\"))"
}

main "$@"
