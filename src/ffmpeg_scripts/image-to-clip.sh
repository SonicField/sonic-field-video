#!/bin/zsh

# Description:
# Make and image into a clip and fade into and out from the image from a colour.
# The fade will be 0.25 seconds.
# 
# Args:
# <image> <seconds-lenght> 
#
# Out:
# <*->.nut

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${enc} -ss 0 -to '${2}' -filter_complex \
'
[0:v]
loop=
    loop=-1:
    start=0:
    size=$((${r}*${2})),
fps=${r},
scale=
    size=1920x1080:
    flags=lanczos,
setsar=1:1
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
' -map '[v]' -map '[a]' '${1%.*}-image.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
