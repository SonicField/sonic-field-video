#!/bin/zsh
# Description:
# Use scaling to perform a very slight anti-alias effect.
# It is very close to a blur but works nicely to not make the image look
# blurred.
#
# Args:
# <video in name>
#
# Out:
# <in name>-finalized.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -v verbose -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale,
format=gbrpf32le,
zscale=
   w=iw*2:
   h=ih*2,
zscale=
   w=iw/2:
   h=ih/2
[v]
\" -map '[v]' -map_metadata -1 'tempv.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i tempv.nut -i '$1' -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-finalized.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
