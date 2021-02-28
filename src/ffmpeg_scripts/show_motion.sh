#!/bin/zsh

# Description:
# Shows only the changing parts of a video.
#
# Args:
# <video in> 
#
# Out:
# <*-motion>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
format=rgba,
tblend=
   all_mode=difference
[v]
\" -map '[v]' '${1%.*}-motion.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

