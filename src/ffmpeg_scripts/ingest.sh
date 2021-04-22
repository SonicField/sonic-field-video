#!/bin/zsh
# Description:
# Ingest a video using the given lut:
#
# In general the pipleline is run with a lumance 4 stops brighter than normal
# to take advantage of the bit depth and dropped at the final render.
#
# e.g to get into the pipeline:
# =============================
# Fuji flog: flog_0-Native  - This is normally correct for Fuji flog is exposed OK.
# bt709:     laminance_4p00 - Example of bringing in BT709
#
# Args:
# <video in name> <lut>
#
# Out:
# <in-lut>.nut
#

. $(dirname "$0")/encoding.sh
lut=$(get_lut $2)
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
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-lut-${2}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-lut-${2}.nut"
