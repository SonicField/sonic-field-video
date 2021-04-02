#!/bin/zsh
# Description:
# Ingest video for editing from full HD Obs feed or the logic direect.
#
# Args:
# <video in name>
#
# Out:
# <in name-fuji>.nut
#

a=0.555556
b=0.009468
c=0.344676
d=0.790453
e=8.735631
f=0.092864
cut2=0.100537775223865

. $(dirname "$0")/encoding.sh
voff=$( fps_round $2 )
cmd="${exe} -y -i '${1}' -i '${1}' ${bt709_enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
lut3d=
    file='flog-bt709.cube':
    interp=trilinear
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-fuji-709.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i '${1%.*}-fuji-709.nut' -i '${1}' ${enc} -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
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
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-fuji-smpte2084.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm run.sh

render_complete
