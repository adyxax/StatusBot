Width_trayer=$((16 * 3))
Pos_trayer=$(($Pos_date - $Width_trayer))
cmd_trayer="stalonetray -bg '#202020' --geometry 3x1+${Pos_trayer}+0 --icon-gravity NE -i 16"

function trayer_bot ()
{
    trap exit USR1 TERM KILL
    eval $cmd_trayer
}

