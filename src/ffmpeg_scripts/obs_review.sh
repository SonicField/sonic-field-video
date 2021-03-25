#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name> 
#
# Out:
# <in name-logi>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${review_enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
format=gbrp16le,
zscale=
    npl=10000:
    size=1920x1080:
    f=point:
    d=none:
    rin=full:
    r=full:
    t=linear,
tonemap=linear:
    param=4.0:
    desat=0,
zscale=
    npl=10000:
    rin=full:
    r=full:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' '${1%.*}-review.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
