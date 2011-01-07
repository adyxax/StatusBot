Width_temperature=$((6 * 3 + 23))
Pos_temperature=$(($Pos_battery - $Width_temperature))
DZEN_temperature="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_temperature -y 0 -w $Width_temperature -h 16 -expand l"

function temperature_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        if [ "$OS" == "OpenBSD" ]; then
            CELCIUS=$(sysctl -n hw.sensors.cpu0.temp0)
            Celcius=${CELCIUS%%.*}
            if [ $Celcius -le 54 ]; then
                Output='^fg(#20EE20)'${Celcius}
            elif [ $Celcius -le 62 ]; then
                Output='^fg(#DCA41C)'${Celcius}
            else
                Output='^fg(#EE2020)'${Celcius}
            fi
        fi
        echo $Output $PicTemp
        sleep 3
    done | $DZEN_temperature
}

