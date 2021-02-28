#!/bin/zsh

# Description:
# Shows difference between two videos
#
# Args:
# <video in> <video in>
#
# Out:
# <*-ndiff>.nut
#

. $(dirname "$0")/encoding-4k.sh
cmd="${exe} -i '${1}' -i '${2}' ${enc} -filter_complex \
\"
[0:v]
format=rgba
[v0];

[1:v]
format=rgba
[v1];

[v1][v0]
blend=
   all_mode=difference,
normalize
[v]
\" -map '[v]' '${1%.*}-ndiff.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

