
### General ##################################################################
ModulePath="$BotPath/modules"

### Colors ###################################################################
NormalFGColor="#999999"
NormalBGColor="#202020"
CurrentFGColor="#5F80D4"
CurrentBGColor=$NormalBGColor
UrgentFGColor="#f57900"
UrgentBGColor=$NormalBGColor
HiddenNoWFGColor="#555555"
HiddenNoWBGColor=$NormalBGColor

### Icons ####################################################################
PicAC="^i($BotPath/icons/power-ac.xbm)"
PicNOAC="^i($BotPath/icons/power-bat.xbm)"
PicVolume="^i($BotPath/icons/volume.xbm)"
PicBat="^i($BotPath/icons/power-bat2.xbm)"
PicTemp="^i($BotPath/icons/temp.xbm)"
PicUp="^fg(orange3)^i($BotPath/icons/arr_up.xbm)^fg()"
PicDown="^fg(#80AA83)^i($BotPath/icons/arr_down.xbm)^fg()"
PicNetWired="^i($BotPath/icons/net-wired2.xbm)"
PicNetWifi="^i($BotPath/icons/net-wifi.xbm)"
Spc="^p(2)"

### Misc #####################################################################
BitmapsDir="/home/julien/config/dzen2"
Font="-*-terminus-medium-*-*-*-12-*-*-*-*-*-iso8859-1"

### Display caracteristics ###################################################
Screens=1
Width_1=1024
Height_1=768

### Modules ##################################################################
source $ModulePath/workspaces.sh
source $ModulePath/ac.sh
source $ModulePath/sound.sh
source $ModulePath/date.sh
source $ModulePath/trayer.sh
source $ModulePath/battery.sh
source $ModulePath/temperature.sh
source $ModulePath/network.sh

