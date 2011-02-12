Width_cpumem=$((6 * 4 + 23))
Pos_cpumem=$(($Pos_temperature - $Width_cpumem))
DZEN_cpumem="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_cpumem -y 0 -w $((120 + 6 * 10)) -h 16 \
-l 2 -tw $Width_cpumem \
-e button1=togglecollapse"

function cpumem_bot ()
{
    trap exit USR1 TERM KILL
    if [ "$OS" == "OpenBSD" ]; then
        MEMTOTBYTES=$(sysctl -n hw.physmem)
        MEMTOT=$(echo ${MEMTOTBYTES} / 1048576 | bc)
    fi
    while true; do
        if [ "$OS" == "OpenBSD" ]; then
            eval `vmstat | tail -n 1 | awk '/[^a-z][0-9\.]+/ {print "MEMFREE=" $5 "; CPUIDLE=" $18 "; SWAPUSED=" $4 ""}'`
            MEMUSED=$(echo ${MEMTOT}' - '${MEMFREE}' / 1024' | bc)
            MEMPCT=$(echo '100 * '${MEMUSED}' / '${MEMTOT} | bc)
            SWAPPCT=$(echo '100 * '${SWAPUSED}' / '${SWAPTOT} | bc)
        else
            eval `awk '/MemTotal/   {mtotal=$2};
                       /^MemFree:/    {mfree=$2};
                       /^Buffers:/    {mbuffers=$2};
                       /^Cached:/     {mcached=$2};
                       /^SwapTotal:/  {swtotal=$2};
                       /^SwapFree:/   {swfree=$2};
                       END { mactive=mtotal - mfree - mbuffers - mcached; swactive=swtotal - swfree; \
                             mpct=int(100*mactive/mtotal); swpct=int(100*swactive/swtotal); \
                             mcolor=mpct<60?20EE20:(mpct<80?DCA41C:EE2020); \
                             swcolor=swpct<10?20EE20:(swpct<20?DCA41C:EE2020); \
                             print "MEMPCT=" int(100 * mactive / mtotal) "; \
                             SWAPPCT=" int(100 * swactive / swtotal) ""}' \
                       /proc/meminfo`
                             #print "^tw()^fg(#" mcolor "" mpct "% " $PicMem "\n"; \
                             #SWAPPCT=" int(100 * swactive / swtotal) ""}' \
        fi

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

        echo "^tw()^fg(${MEMCOLOUR})$MEMPCT"'% '$PicMem
        echo " RAM  : ^fg(${MEMCOLOUR})$MEMPCT"'% '$MEMBAR
        echo " SWAP : ^fg(${SWAPCOLOUR})$SWAPPCT"'% '$SWAPBAR
        sleep 2
    done | $DZEN_cpumem
}

