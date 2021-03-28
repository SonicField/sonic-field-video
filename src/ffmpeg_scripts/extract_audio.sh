#!/bin/zsh
# Description:
# Take the audio from a file and encode to wav
#
# Args:
# <video in name> <offset-time of audio> <green cut e.g. -1>
#
# Out:
# <in name>.wav
#

. $(dirname "$0")/encoding.sh

cmd="${exe} -i '${1}' ${audio_enc} '${1%.*}.wav'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm run.sh

render_complete
