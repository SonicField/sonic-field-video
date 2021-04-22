#!/bin/zsh

# Description:
# Reflect the top of half of a video onto the bottom
#
# Args:
# <video in> 
#
# Out:
# <*-mirror>.nut
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
r='if(gt(Y,H/2),r(X,H-Y), r(X,Y))':
g='if(gt(Y,H/2),g(X,H-Y), g(X,Y))':
b='if(gt(Y,H/2),b(X,H-Y), b(X,Y))',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-mirror.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-mirror.nut"

