#!/bin/zsh

# Description:
# Add a luma curve to a clip
#
# Args:
# <video in> <curve definition>
#
# Out:
# <*-curves>.nut
#
#

# Examples
# ========
#
# This brings up a dark scene without over crushing - like mobius.
# 0/0 0.2/0.10 0.5/0.65 0.8/0.85 1/1'

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le,
curves=
   all='${2}',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-curves.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-curves.nut"

