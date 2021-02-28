#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name>
#
# Out:
# <in name>.nut
#

. $(dirname "$0")/encoding-4k.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex '
[0:v]
setsar=1:1,
setpts=PTS-STARTPTS
[v];

[0:a]
asetpts=PTS-STARTPTS
[a]' -map '[v]' -map '[a]' '${1%.*}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
