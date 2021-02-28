#!/bin/zsh

# Description:
# Turns pixesl in circles
#
# Args:
# <video in> <circle size>
#
# Out:
# <*-pcircle>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
geq=
    r='r(X+sin(X)*${2}, Y+cos(Y)*${2})':
    g='b(X+sin(X)*${2}, Y+cos(Y)*${2})':
    b='b(X+sin(X)*${2}, Y+cos(Y)*${2})':
[v]
\" -map '[v]' '${1%.*}-pcircle.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

