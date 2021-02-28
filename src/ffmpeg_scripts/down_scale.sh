#!/bin/zsh
# Description:
# Upscale to 4K for using in 4K enditing.
#
# Args:
# <video in name>
#
# Out:
# <*-downscaled>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '$1' ${enc} -vf 'scale=1920x1080:flags=bilinear' '${1%.*}-downscaled.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
