#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name> <amount> amount 0.05 makes it slightly warmer for skin tone.
#
# Out:
# <*-warm>.nut
#

red_mid_point=$((0.5 + ${2}))
blue_high_point=$((1.0 - ${2}*2))

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \"
[0:v]
curves=
    r='0/0 0.5/${red_mid_point} 1/1':
    g='0/0 0.5/0.5 1/1':
    b='0/0 0.5/0.4 1/${blue_high_point}'
[v];
\" -map '[v]' '${1%.*}-warm.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
