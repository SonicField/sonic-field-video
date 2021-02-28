#!/bin/zsh

# Description:
# Pixelizes
#
# Args:
# <video overlay> <pixelsize>
#
# Out:
# <*-pixel>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}'  ${enc} -filter_complex \
\"
[0:v]
geq=
    r='r(floor(X/${2}) * ${2}, floor(Y/${2}) * ${2})':
    g='g(floor(X/${2}) * ${2}, floor(Y/${2}) * ${2})':
    b='b(floor(X/${2}) * ${2}, floor(Y/${2}) * ${2})'
[v]
\" -map '[v]' '${1%.*}-pixel.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

