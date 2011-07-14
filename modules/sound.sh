Width_sound=$((6 * 5 + 23))
Pos_sound=$(($Pos_ac - $Width_sound))
DZEN_sound="dzen2 -ta r -sa r -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_sound -y 0 -w $Width_sound -expand l -h 16 \
-e entertitle=grabkeys;leavetitle=ungrabkeys;button1=exec:$BotPath/modules/sound/volume_down.sh;button3=exec:$BotPath/modules/sound/volume_up.sh"

function sound_bot ()
{
    trap exit USR1 TERM KILL
    if [ "$OS" == "OpenBSD" ]; then
        Get_percent='local GRAOU=$(mixerctl -n outputs.master); UGUU=${GRAOU/,*/}; expr $UGUU \* 100 / 255'
    else
        Get_percent='local GRAOU=$(ossmix vmix0-outvol | sed -r '"'"'s/^.*to ([0-9]+)\..*$/\1/'"'"'); expr "$GRAOU" \* 4'
    fi
    old_volume=0
    while true; do
        new_volume="$(eval ${Get_percent})"
        [[ "${new_volume}" == "${old_volume}" ]] && { sleep 1; continue; } || old_volume="${new_volume}"
        echo "^fg($CurrentFGColor)${new_volume}% ${PicVolume}"
    done | $DZEN_sound
}

