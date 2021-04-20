#!/bin/zsh

# Description:
# vstacks two clips into one first at the top second at the bottom
# takes the audio from the first
#
# Args:
# <video top> <video bottom>
#
# Out:
# <*-vstack>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' -i '${2}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le
[vtop];
[2:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le
[vbottom];

[vtop][vbottom]
vstack
[v]
\" -map '[v]' -map 1:a '${1%.*}-vstack.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-vstack.nut"
