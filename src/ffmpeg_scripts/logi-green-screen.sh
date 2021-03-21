#!/bin/zsh
# Description:
# Create an alpha mask where green->white
#
# Args:
# <video in name> <green color code>
#
# Out:
# <in name-mask>.nut
#

# Touch up colour points.
. $(dirname "$0")/encoding.sh
cmd="${exe}  -i '${1}' ${enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
format=gbrp16le,
despill=
    expand=0:
    green=-2:
    blue=0:
    red=0:
    brightness=0,
atadenoise=s=5
zscale=
    t=linear,
tonemap=linear:
    param=1:
    desat=0,
zscale=
    rin=full:
    r=full:
    npl=10000:
    tin=linear:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020
[v]
\" -map '[v]' -map_metadata -1 '${1%.*}-mask.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

