#!/bin/zsh

# Description:
# Make a video into noisy sepia
#
# Args:
# <video in> <noise amount>
#
# Noise amount 1 = light goes up from there
#
# Out:
# <*-old>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
geq=
    lum='min(65535,max(0,lum(X,Y)+random(1)*1024*${2}))':
    cr='32757*1.05':
    cb='32757*0.9',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-old.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-old.nut"

