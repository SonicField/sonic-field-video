#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name> <offset of time in seconds>
#
# Out:
# <in name-logi>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -ss '${2}' -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
zscale=
    f=lanczos:
    size=3840x2160:
    d=error_diffusion:
    rin=limited:
    r=full,
format=gbrpf32le,
curves=
    all='0/0 0.5/0.4 1/1',
zscale=
    t=linear,
tonemap=linear:
    param=256.0:
    desat=0,
zscale=
    rin=full:
    r=full:
    npl=200:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' '${1%.*}-logi.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
