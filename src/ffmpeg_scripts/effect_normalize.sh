#!/bin/zsh

# Description:
# Normalize a video useful for vlogging but not high quality stuff.
#
# Args:
# <video in> 
#
# Out:
# <*-normalize>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
normalize=
    independence=0:
    strength=1:
    smoothing=24,
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-normalize.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-normalize.nut"

