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
zscale=
    f=lanczos:
    size=3840x2160:
    d=error_diffusion:
    rin=limited:
    r=full,
format=gbrp16le,
curves=
    all='0/0 0.5/0.4 1/1',
zscale=
    t=linear,
tonemap=linear:
    param=256.0:
    desat=0,
scale=in_range=full:out_range=full,
zscale=
    r=full:
    npl=200:
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
