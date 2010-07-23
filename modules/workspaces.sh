
DZEN_workspaces="dzen2 -ta l -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x 0 -y 0 -h 16 -w 120 -e 'onstart=lower'"
output_workspaces="initializing..."

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
    trap exit USR1
    while true; do
        echo "$output_workspaces"
        read workspaces || break
        render_workspaces "$workspaces"
    done | $DZEN_workspaces
}

