#!/bin/zsh
# Description:
# Ingest a video using normalization.
# This is good for just bringing in video for vlogging and stuff like that
# which you want about correct straight away without much grading.
#
# Args:
# <video in name> 
#
# Out:
# <in-vlog>.nut
#

. $(dirname "$0")/encoding.sh
lut=$(get_lut flog_0-Native)
clut=$(get_clut reinhard)
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
zscale=rin=full:r=full
[vin];

movie='${clut}',
zscale=rin=full:r=full,
format=gbrpf32le
[vc];

[vin][vc]
haldclut=
    interp=tetrahedral,
zscale=
    rin=full:
    r=full,
curves=
    all='0/0 0.25/0.2 0.75/0.8 1/1',
normalize=
    independence=0:
    strength=0.5:
    smoothing=48,
zscale=
   rin=full:
   r=full
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-vlog.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-vlog.nut"

render_complete
