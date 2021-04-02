#!/bin/zsh

# Description:
# Makes something brighter or darker (exposure basically)
#
# Args:
# <video in> <brighten amount> <gama ammount>
# Fuji looks interesting at 1.1 1.2.
# It will lock overbright to 100% luma - check the waveform!
#
# Out:
# <*-brighten>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
geq=
    lum='min(1.0,pow((lum(X,Y)/65535)*${2},${3}))*65535':
    cr='cr(X,Y)':
    cb='cb(X,Y)',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-brighten.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
