#!/bin/zsh
#
# Description:
# Compensate for incorrect video compared to audio
#
# Args:
# <video in> <video trim> <audio trim> <duration>
#
# Out:
# <*-lagged>.nut

. $(dirname "$0")/encoding.sh
voff=$( fps_round $2 )
aoff=$( fps_round $3 )
totl=$( fps_round $4 )
cmd="${exe} -ss '${voff}' -i '$1' -ss '${aoff}' -i '$1' ${enc} -shortest -to '${totl}' -map 0:v -map 1:a -map_metadata -1 '${1%.*}-lag.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
