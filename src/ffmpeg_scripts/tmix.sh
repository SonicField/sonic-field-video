#!/bin/zsh

# Description:
# tmix by a number of frames
# 
# Args:
# <video in> <frames>
#
# Out:
# <*-mixed>.nut

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${enc}  -filter_complex \
\"
[0:v]
format=yuv444p12le,
tmix=
    frames=${2}
[v]
\" -map '[v]' '${1%.*}-mixed.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
