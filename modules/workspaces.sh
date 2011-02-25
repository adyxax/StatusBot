Width_workspaces=$((120))
Pos_workspaces=0
DZEN_workspaces="dzen2 -ta l -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_workspaces -y 0 -h 16 -w $Width_workspaces"

# Spawning named pipe
[[ -p "/tmp/statusbot.workspaces" ]] || mkfifo "/tmp/statusbot.workspaces"

function render_workspaces ()
{
    local STUFF="$1"
    local IFS="\n"
    local OUTPUT=$(printf "%-20s" "$*")
    export output_workspaces=$(echo $OUTPUT | sed -E \
    's/^(\[.*\])(.*)$/^fg('"$CurrentFGColor"')^bg('"$CurrentBGColor"')\1^fg('"$NormalFGColor"')^bg('"$NormalBGColor"')\2^fg()^bg()/')
}

function workspaces_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        read workspaces
        render_workspaces "$workspaces"
        echo "$output_workspaces"
    done <"/tmp/statusbot.workspaces" | $DZEN_workspaces
    echo "snif"
}

