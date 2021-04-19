#!/bin/zsh
# Description:
# Make a sdr simulated version of a video
# 8 bit
# bt709 complient
#
# Args:
# <video in name>
#
# Out:
# <in-sdr-sim>.nut
#

. $(dirname "$0")/encoding.sh
sdr_lut=$(get_lut hdr-sdr-optimised)
hdr_lut=$(get_lut sdr-hdr)
cmd="${exe} -y -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale=
    rin=full:
    r=full:
    npl=3000:
    rin=full:
    t=bt709:
    m=bt709:
    c=left:
    p=bt709,
format=yuv420p,
zscale=
    npl=3000:
    tin=bt709:
    min=bt709:
    m=bt2020nc:
    p=bt2020:
    t=smpte2084:
    rin=full:
    r=full
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-sdr-sim.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
