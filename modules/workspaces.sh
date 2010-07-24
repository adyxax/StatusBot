
DZEN_workspaces="dzen2 -ta l -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x 0 -y 0 -h 16 -w 120 -e 'onstart=lower'"

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
    while read workspaces; do
        render_workspaces "$workspaces"
        echo "$output_workspaces"
    done | $DZEN_workspaces
}

