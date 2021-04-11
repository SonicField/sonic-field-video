#!/bin/zsh

# Description:
# Simple lock cr and cb to a color - 0.5 0.5 being greytone
#
# Args:
# <video in> <cr> <cb>
#
# Out:
# <*-shift>.nut
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
    lum='lum(X,Y)':
    cr=${2}*65535:
    cb=${3}*65535,
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-crcb.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
