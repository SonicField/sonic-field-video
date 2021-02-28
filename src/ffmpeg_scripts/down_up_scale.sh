#!/bin/zsh
# Description:
# Take 4K and scale to 1080p then back to 4K
#
# Args:
# <video in name>
#
# Out:
# <*-duscaled>.nut
#

. $(dirname "$0")/encoding-4k.sh
cmd="${exe} -i '$1' ${enc} -filter_complex 'scale=1920x1080:flags=bilinear,scale=3840x2160:flags=lanczos' '${1%.*}-duscaled.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
