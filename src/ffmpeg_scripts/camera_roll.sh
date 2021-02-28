#!/bin/zsh

# Description:
# Pretty up an image sequence from imovie
#
# Args:
# <video in> 
#
# Out:
# *-roll.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \"
[0:v]
unsharp=
    lx=13:
    ly=13:
    la=0.5:
    cx=13:
    cy=13:
    ca=0.5,
tmix=
    frames=5:
    weights='1 2 3 4 5',
gradfun
[v]
\" -map '[v]' '${1%.*}-roll.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
