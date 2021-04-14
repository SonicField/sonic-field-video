#!/bin/zsh

# Description:
# Pad then zoom an image
# 
# Args:
# <image> <seconds-lenght> <size - 2 = 1080> <zoom to (e.g. 1.1)> <lr offset> <tb offset>
# lr offset = position to zoom to 0 = left, 0.5 = middle
# tb offset = position to zoom to 0 = top, 0.5 = middle
#
# Out:
# <*-zoom>.nut
#

. $(dirname "$0")/encoding.sh

size=$((960*${3}))x$((540*${3}))
cx=$((960*${3}*${5}))
cy=$((540*${3}*${6}))
scaler=$(( (${4}-1.0)/(${2}*${r}) ))
echo "Frame scaler = ${scaler}"

cmd="${exe} -y -i '${1}' ${bt709_enc} -ss 0 -to '${2}' -filter_complex \
\"
[0:v]
scale=in_range=full:out_range=full,
format=gbrp16le,
pad='ih*16/9:ih:(ow-iw)/2:(oh-ih)/2',
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

cmd="${exe} -i 'tempv.nut' ${enc} -ss 0 -to '${2}' -filter_complex \"
[0:v]
setpts=PTS-STARTPTS,
setsar=1:1,
format=gbrp16le,
geq=
r='r((X-${cx})/(1+${scaler}*N)+${cx}, (Y-${cy})/(1+${scaler}*N)+${cy})':
g='g((X-${cx})/(1+${scaler}*N)+${cx}, (Y-${cy})/(1+${scaler}*N)+${cy})':
b='b((X-${cx})/(1+${scaler}*N)+${cx}, (Y-${cy})/(1+${scaler}*N)+${cy})',
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
\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-zoom.nut'"

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
