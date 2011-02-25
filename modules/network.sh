Width_network=240
Pos_network=$(($Pos_cpumem - $Width_network))
DZEN_network="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_network -y 0 -w $Width_network -h 16 -expand l"

function network_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        if [ "$OS" == "OpenBSD" ]; then
            eval `ifstat -i em0,wpi0 0.1 1 | awk '/[^a-z][0-9\.]+/ {print "EM0DOWN=" $1 "; EM0UP=" $2 "; WPI0DOWN=" $3 "; WPI0UP=" $4}'`
            if [ -n "$(ifconfig em0 |grep -e 'status: active')" ]; then
                EM0TRAF="${EM0DOWN}kB/s${PicDown} ${EM0UP}kB/s${PicUp}"
                PCIINFO="^fg($CurrentFGColor)$PicNetWired^fg() $EM0TRAF"
            else
                PCIINFO=""
            fi
            if [ -n "$(ifconfig wpi0 |grep -e 'status: active')" ]; then
                WPI0TRAF="${WPI0DOWN}kB/s${PicDown} ${WPI0UP}kB/s${PicUp}"
                WIFIINFO="^fg($CurrentFGColor)$PicNetWifi^fg() $WPI0TRAF"
            else
                WIFIINFO=""
            fi
        else
            if [ -n "$(ifconfig eth0 |grep -e 'inet addr')" ]; then
                eval `ifstat eth0 | awk '/^eth0/ {print "EM0DOWN=" $6 "; EM0UP=" $8 ""}'`
                EM0TRAF="$((EM0DOWN / 1024))kB/s${PicDown} $((EM0UP / 1024))kB/s${PicUp}"
                PCIINFO="^fg($CurrentFGColor)$PicNetWired^fg() $EM0TRAF"
            else
                PCIINFO=""
            fi
            if [ -n "$(ifconfig wlan0 |grep -e 'inet addr')" ]; then
                eval `ifstat wlan0 | awk '/^wlan0/ {print "WPI0DOWN=" $6 "; WPI0UP=" $8 ""}'`
                WPI0TRAF="$((WPI0DOWN / 1024))kB/s${PicDown} $((WPI0UP / 1024))kB/s${PicUp}"
                WIFIINFO="^fg($CurrentFGColor)$PicNetWifi^fg() $WPI0TRAF"
            else
                WIFIINFO=""
            fi
        fi
        echo "$PCIINFO $WIFIINFO "
        sleep 1
    done | $DZEN_network
}

