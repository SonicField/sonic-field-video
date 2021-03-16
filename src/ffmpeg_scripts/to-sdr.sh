#!/bin/zsh

font_file=$(dirname "$0")/Arial-Unicode.ttf
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \"
[0:v]
scale=
    in_range=full:
    out_range=full,
drawtext=
    fontfile=${font_file}:
    text='SDR Simulation':
    fontsize=64:
    x=(w-tw)/2:y=h-(2*lh):
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black,
scale=
    in_range=full:
    out_range=full,
format=rgb24
[v]

\" -map '[v]' '${1%.*}-sdr.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
