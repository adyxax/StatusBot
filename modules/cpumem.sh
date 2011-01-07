Width_cpumem=$((6 * 4 + 23))
Pos_cpumem=$(($Pos_temperature - $Width_cpumem))
DZEN_cpumem="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_cpumem -y 0 -w $((120 + 6 * 10)) -h 16 \
-l 2 -tw $Width_cpumem \
-e entertitle=uncollapse;\
enterslave=grabkeys;leaveslave=collapse,ungrabkeys"

function cpumem_bot ()
{
    trap exit USR1 TERM KILL
    if [ "$OS" == "OpenBSD" ]; then
        MEMTOTBYTES=$(sysctl -n hw.physmem)
        MEMTOT=$(echo ${MEMTOTBYTES} / 1048576 | bc)
    else
        MEMTOTBYTES=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
        MEMTOT=$(echo ${MEMTOTBYTES} / 1024 | bc)
        SWAPTOTBYTES=$(cat /proc/meminfo | grep SwapTotal | awk '{ print $2 }')
        SWAPTOT=$(echo ${SWAPTOTBYTES} / 1024 | bc)
    fi
    while true; do
        if [ "$OS" == "OpenBSD" ]; then
            eval `vmstat | tail -n 1 | awk '/[^a-z][0-9\.]+/ {print "MEMFREE=" $5 "; CPUIDLE=" $18 "; SWAPUSED=" $4 ""}'`
        else
            eval `vmstat | tail -n 1 | awk '/[^a-z][0-9\.]+/ {print "MEMFREE=" $4 "; CPUIDLE=" $15 "; SWAPUSED=" $3 ""}'`
        fi
        MEMUSED=$(echo ${MEMTOT}' - '${MEMFREE}' / 1024' | bc)
        MEMPCT=$(echo '100 * '${MEMUSED}' / '${MEMTOT} | bc)
        SWAPPCT=$(echo '100 * '${SWAPUSED}' / '${SWAPTOT} | bc)

        if [ "${MEMPCT}" -lt 60 ]; then
            MEMCOLOUR='#20EE20'
        elif [ "${MEMPCT}" -lt 80 ]; then
            MEMCOLOUR='#DCA41C'
        else
            MEMCOLOUR='#EE2020'
        fi
        MEMBAR="$(echo ${MEMPCT}|gdbar -fg ${MEMCOLOUR} -bg '#37383a' -w 100 -h 6 -sh 16 -nonl)"

        if [ "${SWAPPCT}" -lt 10 ]; then
            SWAPCOLOUR='#20EE20'
        elif [ "${SWAPPCT}" -lt 30 ]; then
            SWAPCOLOUR='#DCA41C'
        else
            SWAPCOLOUR='#EE2020'
        fi
        SWAPBAR="$(echo ${SWAPPCT}|gdbar -fg ${SWAPCOLOUR} -bg '#37383a' -w 100 -h 6 -sh 16 -nonl)"

        echo "^fg(${MEMCOLOUR})$MEMPCT"'% '$PicMem
        echo " RAM  : ^fg(${MEMCOLOUR})$MEMPCT"'% '$MEMBAR
        echo " SWAP : ^fg(${SWAPCOLOUR})$SWAPPCT"'% '$SWAPBAR
        sleep 2
    done | $DZEN_cpumem
}

