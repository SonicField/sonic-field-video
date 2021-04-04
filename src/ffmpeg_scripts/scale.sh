#!/bin/zsh
# Description:
# Scale to size times 960x540.
# 2 = HD
# 4 = 4k
# 8 = 8K
#
# Args:
# <video in name> <size>
#
# Out:
# <*-scaled>.nut
#

size=$((960*${2}))x$((540*${2}))

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '$1' ${enc} -vf '
format=gbrpf32le,
zscale=
    size=${size}:
    d=error_diffusion:
    f=lanczos:
    rangein=full:
    range=full' '${1%.*}-scaled.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
