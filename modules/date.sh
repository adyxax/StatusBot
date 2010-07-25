Width_date=$((18 * 6))
Pos_date=$(($Pos_ac - $Width_date))
DZEN_date="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_date -y 0 -w $Width_date -h 16 -e 'onstart=lower'"

function date_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        echo "$(date +'%Y-%m-%d %H:%M')"
        sleep 1
    done | $DZEN_date
}

