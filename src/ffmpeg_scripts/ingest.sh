#!/bin/zsh
# Description:
# Ingest a fuji XT4 using the flog->bt709 lut.
# This produces lower contrast more constrained video - see flog-direct.sh
# for a better way to injest flog.
#
# Args:
# <video in name>
#
# Out:
# <in>.nut
#

. $(dirname "$0")/encoding.sh
voff=$( fps_round $2 )
cmd="${exe} -y -i '${1}' -i '${1}' ${twelve_bit_enc} -filter_complex \"
[0:v]
zscale=rin=full:r=full,
setpts=PTS-STARTPTS,
setsar=1:1,
zscale=rin=full:r=full,
format=gbrp16le,
lut3d=
    file='flog-bt709.cube':
    interp=trilinear,
zscale=rin=full:r=full,
format=gbrpf32le,
zscale=
    rin=full:
    r=full:
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

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0") ./review.sh '${1%.*}.nut'
