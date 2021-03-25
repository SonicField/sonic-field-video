#!/bin/zsh

# Description:
# Make a video monochrome
#
# Args:
# <video in> 
#
# Out:
# <*-monochrome>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
'
[0:v]
zscale=
   rin=full:
   r=full,
format=gray16le,
zscale=
   rin=full:
   r=full
[v]
' -map '[v]' '${1%.*}-monochrome.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

