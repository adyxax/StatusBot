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

# Restart function {{{
sons=()
function bot_restart ()
{
    echo "[statusbot] rebooting..."
    for son in ${sons[@]}
    do
        kill -9 $son || true
    done
    exec $BotPath/statusbot.sh
}
# }}}

# Spawn function {{{
function spawn ()
{
    eval "$@" &
    sons[${#sons[@]}]="$!"
}
# }}}

trap 'exit 1' KILL TERM

# Spawning modules
spawn workspaces_bot
spawn title_bot
spawn network_bot
spawn cpumem_bot
spawn temperature_bot
spawn battery_bot
spawn trayer_bot
spawn date_bot
spawn sound_bot
spawn ac_bot

[[ -p "/tmp/statusbot.cli" ]] || (rm -f /tmp/statusbot.cli && mkfifo "/tmp/statusbot.cli") || true
while true; do
    read cmd
    case $cmd in
        "reboot") bot_restart;;
        *) echo "$cmd: invalid command";;
    esac
done <"/tmp/statusbot.cli"

