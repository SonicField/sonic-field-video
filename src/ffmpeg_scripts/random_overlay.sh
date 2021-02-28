#!/bin/zsh

# Description:
# Overlays one image on another using random pixels
#
# Args:
# <video overlay> <video base>
#
# Out:
# <*-randover>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' ${enc} -filter_complex \
\"
[0:v]
format=rgba,
geq=
    r='r(X,Y)':
    g='g(X,Y)':
    b='b(X,Y)':
    a='gt(random(1),0.5) *  255'
[over];

[1:v][over]
overlay
[v]
\" -map '[v]' '${1%.*}-randover.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

