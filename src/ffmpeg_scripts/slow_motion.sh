#!/bin/zsh

# Description:
# Use motion interpolation to slow down a video.
# This will drop the audio and make silence.
#
# Args:
# <video in> <slow amount> <base framerate>
#
# Out:
# <*-slow>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex '
'
[0:v]
minterpolate=
    fps=${r}*${2}:
    mi_mode=mci:
    mc_mode=obmc:
    me_mode=bidir:
    me=epzs:
    mb_size=16,
tblend=
    all_mode=average,
minterpolate=
    fps=${r}*${2}:
    mi_mode=mci:
    mc_mode=obmc:
    me_mode=bidir:
    me=epzs:
    mb_size=16,
tblend=
    all_mode=average,
setpts=PTS*${2},
fps=${r}
[v]
;

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]' -map '[v]' -map '[a]' '${1%.*}-slow.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

