#!/bin/zsh
# Description:
# Use scaling to perform a very slight anti-alias effect.
# It is very close to a blur but works nicely to not make the image look
# blurred.
# I added in a slight gamma twise to improve definition at the high end in
# HDR and HDR -> SDR downscale for youtube.
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
format=gbrp16le,
curves=
    all='0/0 0.25/0.25 0.75/0.7 1/1',
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

cmd="${exe} -i tempv.nut -i '$1' -i '$4' -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-finalized.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
