#!/bin/zsh
# Description:
# Make and image into a clip and fade into the image from a colour.
# The fade will be 0.25 seconds.
# 
# Args:
# <image> <seconds-lenght> <colour> <fade in from colour> 
#
# Out:
# <*-fade-in>.nut
#

. ./$(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -t '$2' -filter_complex  '
[0:v]
loop=
    loop=-1:
    start=0:
    size=$((${r}*${2})),
fps=${r},
format=rgb24,
scale=1920x1080,
fade=
    t=in:
    st=0:
    d=0.25:
    c=${3},
setsar=1:1
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K[a]
'  -map '[v]' -map '[a]' '${1%.*}-find-in.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

