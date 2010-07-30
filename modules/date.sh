Width_date=$((18 * 6))
Pos_date=$(($Pos_sound - $Width_date))
DZEN_date="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_date -y 0 -w $Width_date -h 16 -expand l -e 'onstart=lower'"

function date_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        Hour=$(date +'%H')
        if [ $Hour -ge 9 -a $Hour -lt 12 ]; then
            Color='^fg(#20EE20)'
        elif [ $Hour -ge 12 -a $Hour -lt 14 ]; then
            Color='^fg(#DCA41C)'
        elif [ $Hour -ge 14 -a $Hour -lt 18 ]; then
            Color='^fg(#20EE20)'
        elif [ $Hour -ge 18 -a $Hour -lt 22 ]; then
            Color='^fg(#DCA41C)'
        else
            Color='^fg(#EE2020)'
        fi
        echo "$Color$(date +'%Y-%m-%d %H:%M')"
        sleep 1
    done | $DZEN_date
}

