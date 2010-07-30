Width_ac=23
Pos_ac=$(($Width_1 - $Width_ac))
DZEN_ac="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_ac -y 0 -w $Width_ac -h 16 -expand l -e 'onstart=lower'"

function ac_bot ()
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
        echo "$OutputAC"
        sleep 1
    done | $DZEN_ac
}

