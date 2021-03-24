#!/bin/zsh
# Description:
# Ingest video for editing from full HD Obs feed or the logic direect.
#
# Args:
# <video in name>
#
# Out:
# <in name-logi>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
format=gbrp16le,
atadenoise,
format=gbrpf32le,
zscale=
    t=linear,
tonemap=linear:
    param=4:
    desat=0,
zscale=
    size=3840x2160:
    rin=full:
    r=full:
    npl=10000:
    tin=linear:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-logi.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i '${1}' ${audio_enc} '${1%.*}-logi.wav'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm run.sh

