#!/bin/zsh
# Description:
# Ingest a video using normalization.
# This is good for just bringing in video for normalizeging and stuff like that
# which you want about correct straight away without much grading.
#
# Args:
# <video in name> 
#
# Out:
# <in-normalize>.nut
#

. $(dirname "$0")/encoding.sh
lut=$(get_lut flog_0-Native)
cmd="${exe} -y -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale=rin=full:r=full,
setpts=PTS-STARTPTS,
setsar=1:1,
zscale=rin=full:r=full,
format=gbrp16le,
lut3d=
    file='${lut}':
    interp=tetrahedral,
normalize=
    independence=0:
    strength=1:
    smoothing=24,
zscale=rin=full:r=full
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-normalize.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-normalize.nut"

render_complete
