#!/bin/zsh
#
# Description:
# Add audio to a video.
#
# Args:
# <video in> <audio in> <output>
#
# Out:
# <*-audio>.nut

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '$1' -i '$2' ${enc} -map 0:v -map 1:a '${1%.*}-audio.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $command > run.sh
. ./run.sh
