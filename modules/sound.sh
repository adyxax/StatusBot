Width_sound=23
Pos_sound=$(($Pos_ac - $Width_sound))
DZEN_sound="dzen2 -ta r -sa r -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_sound -y 0 -w 170 -expand l -h 16 \
-l 1 -tw $Width_sound \
-e 'onstart=lower;\
entertitle=uncollapse;\
enterslave=grabkeys;leaveslave=collapse,ungrabkeys;\
button1=menuexec;button2=togglestick;button3=exit:13;\
button4=scrollup;button5=scrolldown;\
key_Escape=ungrabkeys,exit'"

function sound_bot ()
{
    trap exit USR1 TERM KILL
    if [ "$OS" == "OpenBSD" ]; then
        Get_percent='local GRAOU=$(mixerctl -n outputs.master); UGUU=${GRAOU/,*/}; expr $UGUU \* 100 / 255'
    fi
    old_volume=0
    while true; do
        new_volume=$(eval ${Get_percent})
        echo "${PicVolume}"
        VolumeBar="$(echo $new_volume |gdbar -fg ${CurrentFGColor} -bg ${CurrentBGColor} -w 100 -h 8 -sw 120 -sh 16 -nonl)"
        old_volume=$new_volume
        echo ' '$new_volume'% : - '$VolumeBar' +'
        sleep 1
    done | $DZEN_sound
}

