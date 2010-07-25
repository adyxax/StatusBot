#!/usr/bin/env bash
set -eu

# First we perform some initialisations
BotPath="$HOME/prog/statusbot"
trap "rm -f /tmp/statusbot.pid" EXIT
echo $$ > /tmp/statusbot.pid
OS=$(uname -s)
# Then, we kill any remnent of dzen bar or stalonetray
[[ -n "$(pgrep -U $UID dzen)" ]] && pkill -U julien dzen || true
[[ -n "$(pgrep -U $UID stalonetray)" ]] && pkill -U julien stalonetray || true
# Then we source the settings file
source $BotPath/settings.sh

# Restart function {{{
function bot_restart ()
{
    echo "[statusbot] rebooting..."
    trap 'exec $BotPath/statusbot.sh' EXIT
    exit 0
}
# }}}

trap 'exit 1' KILL TERM
trap bot_restart USR1

coproc WorkspaceBot { workspaces_bot; }
trayer_bot &
date_bot &
ac_bot &

while read workspaces; do
    echo "$workspaces" >&${WorkspaceBot[1]}
done

