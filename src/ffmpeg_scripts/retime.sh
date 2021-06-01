#!/bin/zsh

# Description:
# Use motion interpolation to slow down a video.
# This will drop the audio and make silence.
#
# Args:
# <video in> <different in initial frame rate>
#
# 2 = 2x1 slow mo via frame doubling
#
# Out:
# <*-retime>.nut
#

. $(dirname "$0")/encoding.sh
nr=$((${2} * ${r}))
len=$($(dirname "$0")/get_length.sh "${1}")
len=$((${len} * ${2}))
cmd="${exe} -i '${1}' ${enc} -to ${len} -filter_complex '
[0:v]
zscale=
    rin=full:
    r=full,
fps=${nr},
setpts=PTS*${2},
fps=${r},
zscale=
    rin=full:
    r=full
[v]
;

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]' -map '[v]' -map '[a]' '${1%.*}-retime.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-retime.nut"

