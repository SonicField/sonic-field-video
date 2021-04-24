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
lut=$(get_clut $2)
cmd="${exe} -y -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale=rin=full:r=full,
format=gbrpf32le
[vin];

movie='${lut}',
zscale=rin=full:r=full,
format=gbrpf32le
[vc];

[vin][vc]
haldclut,
zscale=rin=full:r=full
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-${2}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-${2}.nut"
