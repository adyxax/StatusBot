
DZEN_background="dzen2 -ta l -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x 0 -y 0 -h 16 -w $Width_1"

function background_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        sleep 5
    done | $DZEN_background
}

