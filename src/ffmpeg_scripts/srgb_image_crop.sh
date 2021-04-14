#!/bin/zsh

# Description:
# Tidy up an image for 4K
# 
# Args:
# <image> <seconds-lenght> <size - 2 = 1080>
#
# Out:
# <*-image>.nut
#

size=$((960*${3}))x$((540*${3}))

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
    size=${size}:
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
\" -map '[v]' -map '[a]' 'tempv.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i 'tempv.nut' -i '${1}' ${enc} -ss 0 -to '${2}' -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
format=gbrpf32le,
zscale=
    rin=full:
    r=full:
    npl=3000:
    tin=bt709:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-image.nut'"

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
