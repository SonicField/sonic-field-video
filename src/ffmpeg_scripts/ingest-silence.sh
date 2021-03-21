#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name>
#
# Out:
# <in name>.nut
#

. $(dirname "$0")/encoding.sh
len=$($(dirname "$0")/get_length.sh "${1}")
cmd="${exe} -i '${1}' ${enc} -to "${len}" -filter_complex '
[0:v]
setsar=1:1,
setpts=PTS-STARTPTS,
atadenoise,
format=gbrpf32le,
zscale=
    f=lanczos:
    size=3840x2160:
    d=error_diffusion:
    r=full,
zscale=
    t=linear,
tonemap=linear:
    param=256.0:
    desat=0,
zscale=
    r=full:
    npl=100:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]' -map '[v]' -map '[a]' '${1%.*}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
