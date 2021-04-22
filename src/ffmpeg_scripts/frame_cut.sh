#!/bin/zsh

# Description:
# Cut a video between two points based on frames.
# Note that unlike time_cut, this is inclusive of the last frame so
# if you join 0-100 100-1000 - frame 100 would be duplicated.
#
# Args:
# <video in> <cut from frame> <cut to frame> 
#
# Out:
# <*-(from)f-t(fo)>.nut
#

. $(dirname "$0")/encoding.sh

start=$((1.0 * ${2} / ${r}))
# Add one frame at the end as numbering starts at zero!
end=$(((1.0 + ${3}) / ${r} ))
length=$(printf %.f "$((${end} - ${start}))")
cmd="${exe} -i '${1}' -c:v copy -c:a copy -ss ${start} -to ${end} '${1%.*}-${2}f-${3}f.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
