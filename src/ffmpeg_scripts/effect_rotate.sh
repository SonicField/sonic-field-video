#!/bin/zsh

# Description:
# Rotate a video by the given angle around the center
#
# Args:
# <video in> <angle degrees>
#
# Out:
# <*-rotate>.nut
#

# Compute the zoom amount required.

# Compute the angle in radians.

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
\" -map '[v]' -map 1:a '${1%.*}-rotate.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-rotate.nut"

