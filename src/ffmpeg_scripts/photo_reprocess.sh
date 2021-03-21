#!/bin/zsh

# Description:
# Tidy up an image for 4K
# 
# Args:
# <image> <seconds-lenght> 
#
# Out:
# <*-reprocesed>.nut

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${enc} -ss 0 -to '${2}' -filter_complex \
\"
[0:v]
scale=in_range=full:out_range=full,
format=gbrp16le,
scale=
    size=3840x2160:
    out_range=full:
    flags=lanczos,
normalize=
    strength=1:
    independence=0,
split=2
[v1][v2];

[v1]
scale=in_range=full:out_range=full,
unsharp=
    lx=13:
    ly=13:
    la=5:
    cx=13:
    cy=13:
    ca=5,
bilateral=
    sigmaS=0.2:
    sigmaR=0.2:
    planes=9,
scale=in_range=full:out_range=full
[vb];

[v2][vb]
blend=
    all_mode=softlight,
normalize=
    strength=1:
    independence=0,
loop=
    loop=-1:
    start=0:
    size=$((${r}*${2})),
fps=${r},
setsar=1:1,
scale=in_range=full:out_range=full
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' '${1%.*}-reprocessed.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

# If not 16/9
# crop=
#   out_w=in_w:
#   out_h=in_w*9/16:
#   x=0:
#   y=in_h-(in_w*9/16)/2,
