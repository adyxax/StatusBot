Width_trayer=$((16 * 3))
Pos_trayer=$(($Pos_date - $Width_trayer))
cmd_trayer="stalonetray -bg '#202020' --geometry ${Width_trayer}x16+${Pos_trayer}-752 --icon-gravity E -i 16 --max-width ${Width_trayer} --max-height 16"

function trayer_bot ()
{
    trap exit USR1 TERM KILL
    eval $cmd_trayer
}

