#!/bin/zsh

# Description:
# Changes the saturation of a clip then passes the result through a gamu limiter.
#
# In:
# <clip> <amount>
#
# 1 -> no change
# 0.5 -> desaturate
# 2 -> saturate
#
# Out:
# <*-brighten-*params*>.nut
#

. $(dirname "$0")/encoding.sh
lut=$(get_lut bt2020-limiter)
name="saturate-$2"
name=$( echo $name | tr . p)
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
geq=
    lum='lum(X,Y)':
    cr='32767+(cr(X,Y)-32767)*${2}':
    cb='32767+(cb(X,Y)-32767)*${2}',
zscale=
    rin=full:
    r=full,
format=gbrpf32le,
lut3d=
    file='${lut}':
    interp=tetrahedral,
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-${name}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-${name}.nut"
