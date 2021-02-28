#!/bin/zsh

# Description:
# crushes the bits the the passed level and adds edges to the crushed video
#
# Args:
# <video in> <divisor>
#
# Out:
# <*-cedges>.nut
#

. $(dirname "$0")/encoding-4k.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
geq=
r='floor(r(X,Y)/${2}) * ${2}':
g='floor(g(X,Y)/${2}) * ${2}':
b='floor(b(X,Y)/${2}) * ${2}',
split=2
[crushed][edgein];

[edgein]
sobel,
hue=
    s=0
[edges];

[crushed][edges]
blend=
   all_mode=subtract,
normalize
[v]
\" -map '[v]' '${1%.*}-cedges.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

