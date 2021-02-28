#!/bin/zsh

# Description:
# Pixelizes and lagfuns
#
# Args:
# <video in> <pix random size> 
#
# Out:
# <*-grain>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
hue=s=0,
histeq,
vignette,
noise=
    c0s=12:
    allf=t,
unsharp,
gblur,
unsharp
[v]
\" -map '[v]' '${1%.*}-grain.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

