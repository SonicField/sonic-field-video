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
cmd="${exe} -y -i '${1}' ${bt709_enc} -ss 0 -to '${2}' -filter_complex \
\"
[0:v]
scale=in_range=full:out_range=full,
format=gbrp16le,
crop=
    out_w=in_w:
    out_h=in_w*9/16:
    x=0:
    y=in_h-(in_w*9/16)/2,
scale=
    size=5760x3240:
    out_range=full:
    flags=lanczos,
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
\" -map '[v]' -map '[a]' '${1%.*}-reprocessed-bt709.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i '${1%.*}-reprocessed-bt709.nut' -i '${1}' ${enc} -ss 0 -to '${2}' -filter_complex \"
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
    size=5760x3240:
    rin=full:
    r=full:
    npl=10000:
    tin=linear:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-reprocessed-smpte2084.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm run.sh

render_complete

# If not 16/9
# crop=
#   out_w=in_w:
#   out_h=in_w*9/16:
#   x=0:
#   y=in_h-(in_w*9/16)/2,
