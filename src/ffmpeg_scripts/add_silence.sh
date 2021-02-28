#!/bin/zsh

# Description:
# Make a mono video into stereo.
#
# Args:
# <video in>
#
# Out:
# <*-stereo>.nut
#

len=$($(dirname "$0")/get_length.sh "${1}")

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${enc} -ss 0 -to ${len} -filter_complex \
'
[0:v]
copy
[v]
;

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]' -map '[v]' -map '[a]' '${1%.*}-silence.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

