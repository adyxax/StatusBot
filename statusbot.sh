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
    echo "[statusbot] rebooting..."
    trap 'exec $BotPath/statusbot.sh' EXIT
    exit 0
}
# }}}

# Terminate function {{{
function bot_terminate ()
{
    exit 0
}
# }}}

trap bot_terminate KILL TERM
trap bot_restart USR1
trap bot_fallback ERR

coproc WorkspaceBot { workspaces_bot; }
trayer_bot &
date_bot &

while read workspaces; do
    echo "$workspaces" >&${WorkspaceBot[1]}
done

