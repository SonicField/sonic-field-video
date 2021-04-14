#!/bin/zsh
# Description:
# Apply a cube lut to a video.
#
# Args:
# <video in name> <lut>
#
# Out:
# <in-cube>.nut
#

. $(dirname "$0")/encoding.sh
lut=$(get_lut $2)
cmd="${exe} -y -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale=rin=full:r=full,
format=gbrpf32le,
lut3d=
    file='${lut}':
    interp=tetrahedral,
zscale=rin=full:r=full
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-cube.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
