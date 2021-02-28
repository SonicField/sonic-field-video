#!/bin/zsh

# Description:
# Overlay an image on the a video at a particular time and point
#
# Args:
# <image overlay> <video base> <start> <end> <x> <y> 
#
# Out:
# <*-overlay>.nut
#
#

len=$($(dirname "$0")/get_length.sh "${2}")
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' ${enc} -ss 0 -to ${len} -filter_complex \
'
[0:v]
loop=
    loop=-1:
    start=0:
    size=${len},
fps=${r},
fade=
    t=in:
    st=${3}:
    d=0.25:
    alpha=1,
fade=
    t=out:
    st=$((${4}-0.25)):
    d=0.25:
    alpha=1
[img];

[1:v][img]
overlay=
    x=${5}:
    y=${6}
[v]
' -map '[v]' -map 1:a '${2%.*}-overlay.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

