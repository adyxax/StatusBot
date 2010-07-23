#!/usr/bin/env bash
set -eu

# First we perform some initialisations
BotPath="$HOME/prog/statusbot"

# Then, we kill any remnent of dzen bar
[[ -n "$(pgrep -U julien dzen)" ]] && pkill -U julien dzen || true
# Then we source the settings file
source $BotPath/settings.sh

# Fallback function {{{
function bot_fallback ()
{
    trap bot_restart USR1
    # set another trap on SIG_ERR that would just display a dzen warning and wait for a SIG_USR1 reload to avoid crashes on updates
    while true; do
        echo "^fg('"$CurrentFGColor"')^bg('"$CurrentBGColor"')StatusBot has detected an abnormal error. If you see this message,
        go fix your code then send a SIG_USR1 to the statusbot to restart it." | \
        sleep 10
    done | dzen2 -ta l -sa l -fg "$NormalFGColor" -bg "$NormalBGColor" -fn "$Font" -x 0 -y 0 -h 16
}
# }}}

# Restart function {{{
function bot_restart ()
{
    echo "[statusbot] Got reloading signal, waiting for subprocesses to die..."
    bot_terminate
    wait
    echo "[statusbot] rebooting..."
    $BotPath/statusbot.sh <&0 &
    exit 0
}
# }}}

# Terminate function {{{
function bot_terminate ()
{
    trap - USR1 ERR KILL TERM
}
# }}}

trap bot_terminate KILL TERM
trap bot_restart USR1
trap bot_fallback ERR

coproc WORKSPACES_BOT { workspaces_bot; }
date_bot &

while true; do
    if read -t 185 workspaces; then
        echo "$workspaces" >&${WORKSPACES_BOT[1]}
    fi
done
trap - USR1 ERR KILL TERM

