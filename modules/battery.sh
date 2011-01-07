Width_battery=$((6 * 4 + 23))
Pos_battery=$(($Pos_trayer - $Width_battery - 6))
DZEN_battery="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_battery -y 0 -w $Width_battery -h 16 -expand l"

function battery_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        if [ "$OS" == "OpenBSD" ]; then
            eval `sysctl -n \
            hw.sensors.acpibat0.watthour0 \
            hw.sensors.acpibat0.watthour3 \
            hw.sensors.acpibat0.raw1 \
            hw.sensors.acpiac0.indicator0 \
            hw.sensors.cpu0.temp0 \
            | awk '{print "SYSCTL" NR "=" $1}' `

            # Battery
            BAT_FULL=${SYSCTL1}
            BAT_CURRENT=${SYSCTL2}

            BAT_PERC=`echo "100 * ${BAT_CURRENT} / ${BAT_FULL}" | bc`
        else
            BAT_PERC="$(acpi -b | sed -r 's/^.*, ([0-9]+)%,.*$/\1/')"
        fi

        if [ ${BAT_PERC} -gt 50 ]; then
            BAT='^fg(#20EE20)'${BAT_PERC}"%"
        elif [ ${BAT_PERC} -gt 20 ]; then
            BAT='^fg(#DCA41C)'${BAT_PERC}"%"
        else
            BAT='^fg(#EE2020)'${BAT_PERC}"%"
        fi
        echo "$BAT $PicBat"
        sleep 10
    done | $DZEN_battery
}

