#!/bin/zsh

# Description:
# Pixelizes zoming from none to 64x64
#
# Args:
# <video overlay> 
#
# Out:
# <*-pzoom>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
geq=
    r='r(floor(X/mod(T*8,64)) * mod(T*8,64), floor(Y/mod(T*8,64)) * mod(T*8,64))':
    g='g(floor(X/mod(T*8,64)) * mod(T*8,64), floor(Y/mod(T*8,64)) * mod(T*8,64))':
    b='b(floor(X/mod(T*8,64)) * mod(T*8,64), floor(Y/mod(T*8,64)) * mod(T*8,64))'
[v]
\" -map '[v]' '${1%.*}-pzoom.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

