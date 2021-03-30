#!/bin/zsh

# Description:
# Shift pixels
#
# Args:
# <video in> 
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
format=gbrp16le,
geq=
r='r(X+5,Y)':
g='g(X-5,Y)':
b='b(X,Y+3)',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-shift.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
