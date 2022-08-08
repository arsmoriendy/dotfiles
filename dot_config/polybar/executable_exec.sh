#!/usr/bin/sh

polybar-msg cmd quit
POLYBAR_DATETIME_LABEL="%date% %{T2}$DISTRO_ICON %{T-} %time%" polybar -r top 2>/tmp/polybar.log
