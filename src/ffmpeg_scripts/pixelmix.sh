#!/bin/zsh

# Description:
# Pixelizes and lagfuns
#
# Args:
# <video in> <pix random size> 
#
# Out:
# <*-pmix>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
geq=
    r='r(X+random(1)*${2}, Y+random(1)*${2})':
    g='g(X+random(1)*${2}, Y+random(1)*${2})':
    b='b(X+random(1)*${2}, Y+random(1)*${2})',
lagfun=
    decay=0.9
[v]
\" -map '[v]' '${1%.*}-pmix.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

