Width_date=$((16 * 6 + 32))
Pos_date=$(($Width_1 - $Width_date))
DZEN_date="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_date -y 0 -w $Width_date -h 16 -e 'onstart=lower'"

function date_bot ()
{
    trap exit USR1 TERM KILL
    if [ "$OS" == "OpenBSD" ]; then
        Check_AC='local GRAOU=$(sysctl -n hw.sensors.acpiac0.indicator0); echo ${GRAOU%% *}'
    fi
    while true; do
        if [ $(eval $Check_AC) = "On" ]; then
            OutputAC=${PicAC}
        else
            OutputAC=${PicNOAC}
        fi
        echo "$(date +'%Y-%m-%d %H:%M') $OutputAC"
        sleep 1
    done | $DZEN_date
}

