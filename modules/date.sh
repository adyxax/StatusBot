
DZEN_date="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x 904 -y 0 -h 16 -w 120 -e 'onstart=lower'"

function date_bot ()
{
    trap exit USR1
    while true; do
        echo "$(date +'%Y-%m-%d %H:%M:%S')"
        sleep 1
    done | $DZEN_date
}

