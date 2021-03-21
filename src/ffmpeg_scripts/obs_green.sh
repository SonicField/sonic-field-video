#!/bin/zsh
# Description:
# Ingest from OBS where a green screen has been used
#
# Args:
# <video in name>
#
# Out:
# <in name-green>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale,
despill=
    expand=0:
    green=-2:
    blue=0:
    red=0:
    brightness=0,
zscale,
atadenoise=s=5,
zscale,
format=gbrp16le,
curves=
    r='0/0 0.9/0.85 1/0.9':
    g='0/0 1/1':
    b='0/0 1/0.9',
zscale,
format=gbrpf32le,
zscale=
    t=linear,
tonemap=linear:
    param=1:
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
\" -map '[v]' -map '1:a' '${1%.*}-green.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

