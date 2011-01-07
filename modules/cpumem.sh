Width_cpumem=$((6 * 4 + 23))
Pos_cpumem=$(($Pos_temperature - $Width_cpumem))
DZEN_cpumem="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_cpumem -y 0 -w $((120 + 6 * 10)) -h 16 \
-l 2 -tw $Width_cpumem \
-e onstart=lower;\
entertitle=uncollapse;\
enterslave=grabkeys;leaveslave=collapse,ungrabkeys"

function cpumem_bot ()
{
    trap exit USR1 TERM KILL
    MEMTOTBYTES=$(sysctl -n hw.physmem)
    MEMTOT=$(echo ${MEMTOTBYTES} / 1048576 | bc)
    while true; do
        if [ "$OS" == "OpenBSD" ]; then
            eval `vmstat | tail -n 1 | awk '/[^a-z][0-9\.]+/ {print "MEMFREE=" $5 "; CPUIDLE=" $18 ""}'`
            MEMUSED=$(echo ${MEMTOT}' - '${MEMFREE}' / 1024' | bc)
            MEMPCT=$(echo '100 * '${MEMUSED}' / '${MEMTOT} | bc)
            if [ ${MEMPCT} -lt 60 ]; then
                MEMCOLOUR='#20EE20'
            elif [ ${MEMPCT} -lt 80 ]; then
                MEMCOLOUR='#DCA41C'
            else
                MEMCOLOUR='#EE2020'
            fi
            MEMBAR="$(echo ${MEMPCT}|gdbar -fg ${MEMCOLOUR} -bg '#37383a' -w 100 -h 6 -sh 16 -nonl)"
        fi
        echo "^fg(${MEMCOLOUR})$MEMPCT"'% '$PicMem
        echo " RAM  : ^fg(${MEMCOLOUR})$MEMPCT"'% '$MEMBAR
        echo " SWAP : "
        sleep 2
    done | $DZEN_cpumem
}

