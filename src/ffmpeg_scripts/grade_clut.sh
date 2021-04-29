#!/bin/zsh
# Description:
# Apply a haldclut to a video.
#
# Args:
# <video in name> <clut name>
#
# Out:
# <in-(clut)>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -v verbose -y -i '${1}' -i '${1}' ${enc} -filter_complex \"
movie='${2}',
scale=
    in_range=full:
    out_range=full
[lut];

[0:v]
scale=
    in_range=full:
    out_range=full
[vin];

[vin][lut]
haldclut=
    interp=tetrahedral,
scale=
    in_range=full:
    out_range=full
[v]
\" -map '[v]' -map 1:a -map_metadata -1 '${1%.*}-${2}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-${2}.nut"
