#!/bin/zsh

# Description:
# crushes the bits the the passed level
#
# Args:
# <video in> <divisor>
#
# Out:
# <*-ctrails>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
split=2
[v1][v2];

[v1]
geq=
r='floor(r(X,Y)/${2}) * ${2}':
g='floor(g(X,Y)/${2}) * ${2}':
b='floor(b(X,Y)/${2}) * ${2}',
tmix=
    frames=4:
    weights='0 0 0 1'
[crushed];

[v2]
sobel,
lagfun=
    decay=0.9
[edges];

[crushed][edges]
blend=
   all_mode=addition
[v]
\" -map '[v]' '${1%.*}-ctrails.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

