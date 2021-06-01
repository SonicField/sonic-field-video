#!/bin/zsh

# Description:
# Tmixes a videa
#
# Args:
# <video in> <frame> <quotients>
#
# Out:
# <*-tmix>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
    rin=full:
    r=full,
format=yuv444p16le,
tmix=
    frames=${2}:
    weights='${3}',
zscale=
    rin=full:
    r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-tmix.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-tmix.nut"

