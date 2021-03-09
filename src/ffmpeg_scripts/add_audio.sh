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
cmd="${exe} -i '$1' -i '$2' -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-audio.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
