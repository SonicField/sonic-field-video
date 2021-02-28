#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name>
#
# Out:
# <*-4k>.nut
#

len=$($(dirname "$0")/get_length.sh "${1}")

. $(dirname "$0")/encoding-4k.sh
cmd="${exe} -ss 0.2 -i '${1}' -i '${1}' ${enc} -filter_complex '
[0:v]
deblock,
setsar=1:1,
setpts=PTS-STARTPTS
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]' -map '[v]' -map '[a]' '${1%.*}-4k.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
