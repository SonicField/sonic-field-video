#!/bin/zsh
# Description:
# Add motion blur - sadly only 8 bit
#
# Args:
# <video in name> <frames> <blur>
#
# frames = number of interpolated frames, more is slower but potentially smoother
# blur = amount of blur to add, 1 is between 2 input frames, 2 over three and so on
# Out:
# <in name>-mblur.nut
#

. $(dirname "$0")/encoding.sh

# Compute blur amount factors
frames=${2}
# Add 1 so we span input and output frame
blur=$(( ${frames} * ${3} + 1))

cmd="${exe} -y -v verbose -i '${1}' -i '${1}' ${enc} -output_ts_offset 0 -filter_complex \"
[0:v]
zscale,
format=yuv444p,
zscale,
minterpolate=
    mi_mode=mci:
    me_mode=bidir:
    scd=none:
    fps=$(( ${r} * ${frames} )),
tmix=${blur},
fps=
    start_time=0:
    fps=${r},
zscale
[v]
\" -map '[v]' -map 1:a -map_metadata -1 '${1%.*}-mblur.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh && render_complete

