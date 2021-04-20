#!/bin/zsh

# Description:
# Strange motion effect
#
# Args:
# <video in> <factor e.g. 32> <radius e.g. 5>
#
# 16 7 is nice and smooth but bright
# 4 7 is gentle - sort of broken tape effect with temporal lag
#
# Out:
# <*-motion>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
    rin=full:
    r=full,
amplify=
    factor=${2}:
    radius=${3},
tmix=8:
    weights='8 7 6 5 4 3 2 1',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-motion.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-motion.nut"

