#!/bin/zsh
# Description:
# Ingest from OBS where a green screen has been used
# We upscale 4 times the normal peak to use all the bit depth during
# processing then the final output scripts converts this back down to
# something youtube likes.
#
# Args:
# <video in name> <offset-time of audio> <green cut e.g. -1>
#
# Out:
# <in name-green>.nut
#

. $(dirname "$0")/encoding.sh
voff=$( fps_round $2 )
desat=24
cmd="${exe} -ss '${voff}' -i '${1}' -i '${1}' ${enc} -filter_complex \"
zscale,
setpts=PTS-STARTPTS,
zscale,
despill=
    expand=0:
    green=${3}:
    blue=0:
    red=0:
    brightness=0,
zscale,
atadenoise=s=5,
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
\" -map '[v]' -map '1:a' -map_metadata -1 '${1%.*}-green.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
