#!/bin/zsh

# Description:
# Transpose a clip  
#
# Args:
# <video in> <transposition>
# 0 = 90 CounterCLockwise and Vertical Flip (default)
# 1 = 90 Clockwise
# 2 = 90 CounterClockwise
# 3 = 90 Clockwise and Vertical Flip 
#
# Out:
# <*-transpose>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
transpose=${2}
[v]
\" -map '[v]' -map 1:a '${1%.*}-transpose.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
