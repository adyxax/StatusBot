Width_title=$((6 * 42))
Pos_title=$(($Pos_workspaces + $Width_workspaces + 6))
DZEN_title="dzen2 -ta l -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_title -y 0 -h 16 -w $Width_title"

# Spawning named pipe
[[ -p "/tmp/statusbot.title" ]] || mkfifo "/tmp/statusbot.title"

function title_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        read title
        echo "$title"
    done <"/tmp/statusbot.title" | $DZEN_title
}

