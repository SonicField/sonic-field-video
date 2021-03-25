#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name> <offset of time in seconds>
#
# Out:
# view.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${review_enc} -vf \"
zscale=
    size=1920x1080:
    rin=full:
    r=full
\"  'view.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
