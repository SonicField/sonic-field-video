#!/bin/zsh

# Description:
# Show the forward motion vectors
#
# Args:
# <video in> 
#
# Out:
# <*-vectors>.nut
#

. $(dirname "$0")/encoding.sh

cmd="${exe} -y -i '${1}' ${review_enc} -max_muxing_queue_size 16384 'tempv.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -flags2 +export_mvs -i tempv.nut ${enc} -max_muxing_queue_size 16384 -vf '
zscale,
codecview=
    mv_type=fp,
zscale
' '${1%.*}-vectors.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

