#!/bin/zsh

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \"
[0:v]
scale=
    in_range=full:
    out_range=full:
    sws_dither=none,
format=yuv420p,
scale=
    in_range=full:
    out_range=full:
    sws_dither=none
[v]

\" -map '[v]' '${1%.*}-sdr.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
