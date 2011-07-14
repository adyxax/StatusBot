Width_cpumem=$((6 * 5 + 23))
Pos_cpumem=$(($Pos_temperature - $Width_cpumem))
DZEN_cpumem="dzen2 -ta r -sa l -fg $NormalFGColor -bg $NormalBGColor -fn $Font -x $Pos_cpumem -y 0 -w $((100 + 6 * 12)) -h 16 \
-l 2 -tw $Width_cpumem \
-e button1=togglecollapse"

function cpumem_bot ()
{
    trap exit USR1 TERM KILL
    while true; do
        eval `awk '/^MemTotal:/   {mtotal=$2};
                   /^MemFree:/    {mfree=$2};
                   /^Buffers:/    {mbuffers=$2};
                   /^Cached:/     {mcached=$2};
                   /^SwapTotal:/  {swtotal=$2};
                   /^SwapFree:/   {swfree=$2};
                   END { mactive=mtotal - mfree - mbuffers - mcached; swactive=swtotal - swfree; \
                         mpct=int(100*mactive/mtotal); swpct=int(100*swactive/swtotal); \
                         mcolor=mpct<60?"#20EE20":(mpct<80?"#DCA41C":"#EE2020"); \
                         swcolor=swpct<10?"#20EE20":(swpct<20?"#DCA41C":"#EE2020"); \
                         print "MCOLOR=" mcolor "; SWCOLOR=" swcolor "; \
                         MEMPCT=" mpct "; \
                         SWAPPCT=" swpct "" }' \
                   /proc/meminfo`
        MEMBAR="$(echo ${MEMPCT}|gdbar -fg ${MCOLOR} -bg '#37383a' -w 100 -h 6 -sh 16 -nonl)"
        SWAPBAR="$(echo ${SWAPPCT}|gdbar -fg ${SWCOLOR} -bg '#37383a' -w 100 -h 6 -sh 16 -nonl)"

        printf "^tw()^fg(${MCOLOR})%3d%% ${PicMem}\n" ${MEMPCT}
        printf " RAM :^fg(${MCOLOR})%3d%% $MEMBAR\n" ${MEMPCT}
        printf " SWAP:^fg(${SWCOLOR})%3d%% ${SWAPBAR}\n" ${SWAPPCT}
        sleep 2
    done | $DZEN_cpumem
}

