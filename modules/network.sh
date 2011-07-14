Width_network=240
Pos_network=$(($Pos_cpumem - $Width_network))
DZEN_network="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_network -y 0 -w $Width_network -h 16 -expand l"

function network_bot ()
{
    trap exit USR1 TERM KILL
    epd=0; epu=0; wpd=0; wpu=0
    while true; do
        if [ -n "$(ifconfig eth0 |grep -e 'inet addr')" ]; then
            eval `awk -v epd=$epd -v epu=$epu \
                      '/eth0/ { ed=$2; eu=$10 ; down=ed-epd; up=eu-epu;
                          if (down > 1048576) { down=down/1048576; du="MB" }
                          else if (down > 1024) { down=down/1024; du="KB" }
                          else du="B";
                          if (up > 1048576) { up=up/1048576; uu="MB" }
                          else if (up > 1024) { up=up/1024; uu="KB" }
                          else uu="B" };
                      END { printf("epd=%d; epu=%d; down=%d; up=%d; du=%s; uu=%s", ed, eu, down, up, du, uu) }' \
                      /proc/net/dev`
            PCIINFO="^fg($CurrentFGColor)$PicNetWired^fg() ${down} ${du}${PicDown} ${up} ${uu}${PicUp}"
        else
            PCIINFO=""
        fi
        if [ -n "$(ifconfig wlan0 |grep -e 'inet addr')" ]; then
            eval `awk -v wpd=$wpd -v wpu=$wpu \
                      '/wlan0/ { wd=$2; wu=$10 ; down=wd-wpd; up=wu-wpu;
                          if (down > 1048576) { down=down/1048576; du="MB" }
                          else if (down > 1024) { down=down/1024; du="KB" }
                          else du="B";
                          if (up > 1048576) { up=up/1048576; uu="MB" }
                          else if (up > 1024) { up=up/1024; uu="KB" }
                          else uu="B" };
                      END { printf("wpd=%d; wpu=%d; down=%d; up=%d; du=%s; uu=%s", wd, wu, down, up, du, uu) }' \
                      /proc/net/dev`
            WIFIINFO="^fg($CurrentFGColor)$PicNetWifi^fg() ${down} ${du}${PicDown} ${up} ${uu}${PicUp}"
        else
            WIFIINFO=""
        fi
        echo "${PCIINFO} ${WIFIINFO}"
        sleep 1
    done | $DZEN_network
}

