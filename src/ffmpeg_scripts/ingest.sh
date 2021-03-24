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
cmd="${exe} -i '${1}' ${enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
format=gbrpf32le,
zscale=
    f=lanczos:
    size=3840x2160:
    d=error_diffusion:
    r=full,
zscale=
    t=linear,
tonemap=linear:
    param=4:
    desat=0,
zscale=
    rin=full:
    r=full:
    npl=10000:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
[v];

[0:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
