#!/bin/zsh
# Description:
# Upscale to 4K for using in 4K enditing.
#
# Args:
# <video in name>
#
# Out:
# <*-upscaled>.nut
#

. $(dirname "$0")/encoding-4k.sh
cmd="${exe} -i '$1' ${enc} -vf '
format=yuv444p12le,
zscale=
    size=1920x1080:
    d=error_diffusion:
    f=lanczos:
    rangein=full:
    range=full' '${1%.*}-upscaled.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
