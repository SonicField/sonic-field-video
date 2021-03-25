#!/bin/zsh

# Description:
# Cut a video between two points
#
# Args:
# <video in> <cut from seconds> <cut to seconds> 
#
# Out:
# <*-cut>.nut
#

. $(dirname "$0")/encoding.sh

# Round to the nearest frame - probably not needed but
# best to be careful.

start=$( fps_round $2 )
end=$( fps_round $3 )
length=$(printf %.f "$((${end} - ${start}))")
afade_end=$(printf %.3f "$((${end} - 0.1))")
cmd="${exe} -i '${1}' ${enc} -ss ${start} -to ${end}  '${1%.*}-cut.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

