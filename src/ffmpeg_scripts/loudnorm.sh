#!/bin/zsh

# Description:
# Loudess normalize a video - one pass
#
# Args:
# <video in> 
#
# Out:
# <*-loudnorm>.nut

$(dirname "$0")/ffmpeg -y -i "$1"  -filter_complex '
[0:a]
dynaudnorm=
    compress=10:
    gausssize=51
[a]' -map '[a]' -c:a pcm_s32le -ar 96K temp.wav

. $(dirname "$0")/encoding.sh
#export command="${exe} -i '$1' -i 'temp.wav' ${enc} -map 0:v -map 1:a '${1%.*}-loudnorm.nut'"
echo
echo '================================================================================'
echo Will Run ${command}
echo '================================================================================'
echo
echo $command > run.sh
. ./run.sh

#dynaudnorm
