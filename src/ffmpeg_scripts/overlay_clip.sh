#!/bin/zsh

# Description:
# Overlay an image on the a video at a particular time and point
#
# Args:
# <clip to overlay> <video base> <start> <end> <x> <y> <ratio>
#
# Out:
# <*-overlay>.nut
#
#

. $(dirname "$0")/encoding.sh
len=$($(dirname "$0")/get_length.sh "${2}")
cmd="${exe} -i '${1}' -i '${2}' ${enc} -ss 0 -to ${len} -filter_complex \
'
color=
    color=0x00000000:
    size=1920x1080:
    duration=${3},
format=rgba,
setsar=1:1,
fps=${r}
[cs];

color=
    color=0x00000000:
    size=1920x1080:
    duration=0.5,
format=rgba,
setsar=1:1,
fps=${r}
[ce];

[0:v]
setpts=PTS-STARTPTS,
format=rgba
[vin];

[cs][vin][ce]
concat=
    n=3,
scale=
    w=1920 * ${7}:
    h=1080 * ${7},
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
[ovl];

[1:v]
setpts=PTS-STARTPTS,
format=rgba
[vbase];

[vbase][ovl]
overlay=
    x=${5}:
    y=${6}
[v]
' -map '[v]' '${2%.*}-overlay.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

