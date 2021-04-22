#!/bin/zsh

# Description:
# Cut a video between two points time in seconds.
#
# Args:
# <video in> <cut from seconds> <cut to seconds> 
#
# Out:
# <*-(from)s-(to)s>.nut
#

. $(dirname "$0")/encoding.sh

# Round to the nearest frame - probably not needed but
# best to be careful.

start=$( fps_round $2 )
end=$( fps_round $3 )
length=$(printf %.f "$((${end} - ${start}))")
cmd="${exe} -i '${1}' -c:v copy -c:a copy -ss ${start} -to ${end} '${1%.*}-${2}s-${3}s.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
