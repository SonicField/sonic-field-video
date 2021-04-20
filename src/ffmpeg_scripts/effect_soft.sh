#!/bin/zsh

# Description:
# Soft light blend effect.
#
# Args:
# <video in>
#
# Out:
# <*-soft>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
    rin=full:
    r=full,
format=gbrpf32le,
split=2,
blend=
    all_mode=softlight,
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-soft.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-soft.nut"

