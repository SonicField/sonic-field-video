#!/bin/zsh
# Description:
# Testing ways to interpolate from 8 bit
#
# Args:
# <video in name>
#
# Out:
# <in name>-smooth.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \"
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

cmd="${exe} -i tempv.nut -i '$1' -i '$4' -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-smooth.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
