#!/bin/zsh
# Description:
# Ingest video for editing from full HD Obs feed or the logic direect.
#
# Args:
# <video in name> <offset-time>
#
# Out:
# <in name-4k>.nut
#

. $(dirname "$0")/encoding.sh
voff=$( fps_round $2 )
cmd="${exe} -y -ss '${voff}' -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
format=gbrp16le,
atadenoise,
format=gbrpf32le,
zscale=
    size=3840x2160:
    rin=full:
    r=full:
    npl=3000:
    tin=bt709:
    min=bt709:
    pin=bt709:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-4k.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -y -i '${1}' ${audio_enc} '${1%.*}-4k.wav'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm run.sh

. $(dirname "$0")/review.sh "${1%.*}-4k.nut"
