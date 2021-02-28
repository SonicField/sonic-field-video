#!/bin/zsh

# Description:
# crushes the bits the the passed level
#
# Args:
# <video in> <divisor>
#
# Out:
# <*-crushed>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
geq=
r='floor(r(X,Y)/${2}) * ${2}':
g='floor(g(X,Y)/${2}) * ${2}':
b='floor(b(X,Y)/${2}) * ${2}'
[v]
\" -map '[v]' '${1%.*}-crushed.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

