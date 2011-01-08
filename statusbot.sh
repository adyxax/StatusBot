#!/usr/bin/env bash
set -eu

# First we perform some initialisations
BotPath="$HOME/prog/statusbot"
trap "rm -f /tmp/statusbot.pid" EXIT
echo $$ > /tmp/statusbot.pid
OS=$(uname -s)
# Then, we kill any remnent of dzen bar or stalonetray
[[ -n "$(pgrep -U $UID dzen)" ]] && pkill -9 -U julien dzen || true
[[ -n "$(pgrep -U $UID stalonetray)" ]] && pkill -9 -U julien stalonetray || true
# Then we source the settings file
source $BotPath/settings.sh
sons=()

# Restart function {{{
function bot_restart ()
{
    echo "[statusbot] rebooting..."
    for son in ${sons[@]}
    do
        kill -9 $son
    done
    trap 'exec $BotPath/statusbot.sh' EXIT
    exit 0
}
# }}}


trap 'exit 1' KILL TERM
trap bot_restart USR1

background_bot &
sons[${#sons[@]}]="$!"
sleep .2
coproc WorkspaceBot { workspaces_bot; }
sons[${#sons[@]}]="$WorkspaceBot_PID"
network_bot &
sons[${#sons[@]}]="$!"
cpumem_bot &
sons[${#sons[@]}]="$!"
temperature_bot &
sons[${#sons[@]}]="$!"
battery_bot &
sons[${#sons[@]}]="$!"
trayer_bot &
sons[${#sons[@]}]="$!"
date_bot &
sons[${#sons[@]}]="$!"
sound_bot &
sons[${#sons[@]}]="$!"
ac_bot &
sons[${#sons[@]}]="$!"

while read workspaces; do
    echo "$workspaces" >&${WorkspaceBot[1]}
done

