#!/bin/zsh
# Description:
# Ingest flog video from the Fugi Xt4 using th flog lut.
# This assums the foootage is 10 bit 4k - might work with other stuff
# but might not.
#
# Args:
# <video in name> <offset-time of audio> 
#
# Out:
# <in name-green>.nut
#

. $(dirname "$0")/encoding.sh
voff=$( fps_round $2 )
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \"
zscale,
setpts=PTS-STARTPTS,
zscale,
format=gbrpf32le,
zscale=
    npl=10000:
    t=linear,
tonemap=linear:
    param=4:
    desat=0,
zscale=
    rin=full:
    r=full:
    npl=10000:
    tin=linear:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020
[v]
\" -map '[v]' -map '1:a' -map_metadata -1 '${1%.*}-ingested.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm run.sh

render_complete
