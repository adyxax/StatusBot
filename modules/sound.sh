Width_sound=$((6 * 5 + 23))
Pos_sound=$(($Pos_ac - $Width_sound))
DZEN_sound="dzen2 -ta r -sa r -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_sound -y 0 -w $Width_sound -expand l -h 16 \
-e entertitle=grabkeys;leavetitle=ungrabkeys;button1=exec:$BotPath/modules/sound/volume_down.sh;button3=exec:$BotPath/modules/sound/volume_up.sh"

function sound_bot ()
{
    trap exit USR1 TERM KILL
    old_volume=0
    while true; do
        new_volume=`ossmix vmix0-outvol | awk '{ total = $10 * 4; print total }'`
        [[ "${new_volume}" == "${old_volume}" ]] && { sleep 1; continue; } || old_volume="${new_volume}"
        echo "^fg($CurrentFGColor)${new_volume}% ${PicVolume}"
    done | $DZEN_sound
}

