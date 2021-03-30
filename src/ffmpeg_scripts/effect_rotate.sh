#!/bin/zsh

# Description:
# Rotate colors
#
# Args:
# <video in> 
#
# Out:
# <*-rotate>.nut
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
r='b(X,Y)*mod(T/2,1) + g(X,Y)*(1-mod(T/2,1))':
g='r(X,Y)*mod(T/2,1) + b(X,Y)*(1-mod(T/2,1))':
b='g(X,Y)*mod(T/2,1) + r(X,Y)*(1-mod(T/2,1))',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-rotate.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
