#!/bin/zsh

# Description:
# Replace base video with top video at a particular time.
#
# Args:
# <video base> <video top> <start time>
#
# Out:
# <*-replaced>.nut
#

rlen=$($(dirname "$0")/get_length.sh "${2}")
stime=${3}
etime=$((${3}+${rlen}))
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' -i '${1}' ${enc} -filter_complex \
\"
[1:v]
tpad=
    start=$((${stime} * ${r}))
[vp];

[0:v][vp]
blend=
   all_expr='if(between(T, ${stime}, ${etime}), B, A)'
[v]
\" -map '[v]' -map 2:a '${1%.*}-replaced.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

