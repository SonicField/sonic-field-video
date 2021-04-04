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
cmd="${exe} -y ${audio_enc} -ss 0 -to ${len} -filter_complex \
'
anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]' -map '[a]' 'tempa.wav'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' -i tempa.wav -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-silence.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm tempa.wav
render_complete
