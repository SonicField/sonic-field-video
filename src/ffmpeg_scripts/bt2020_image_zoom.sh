#!/bin/zsh

# Description:
#
# Crop then zoom an image
#
# Args:
# <image> <seconds-lenght> <size - 2 = 1080> <zoom to (e.g. 1.1)> <lr offset> <tb offset>
# lr offset = position to zoom to 0 = left, 0.5 = middle
# tb offset = position to zoom to 0 = top, 0.5 = middle
# Tidy up an image for 4K
# 
# Out:
# <*-zoom>.nut
#

size=$((960*${3}))x$((540*${3}))

. $(dirname "$0")/encoding.sh

size=$((960*${3}))x$((540*${3}))
cx=$((960*${3}*${5}))
cy=$((540*${3}*${6}))
scaler=$(( (${4}-1.0)/(${2}*${r}) ))
echo "Frame scaler = ${scaler}"

cmd="${exe} -y -i '${1}' ${enc} -ss 0 -to '${2}' -filter_complex \
\"
[0:v]
scale=in_range=full:out_range=full,
format=yuv444p16le,
loop=
    size=$((${r}*${2})):
    loop=-1:
    start=0,
crop=
    out_w=in_w:
    out_h=in_w*9/16:
    x=0:
    y=in_h-(in_w*9/16)/2,
$(image_ingest_bt2020 ${size}),
fps=${r},
geq=
    lum='lum((X-${cx})/(1+${scaler}*N)+${cx}, (Y-${cy})/(1+${scaler}*N)+${cy})':
    cr='cr((X-${cx})/(1+${scaler}*N)+${cx}, (Y-${cy})/(1+${scaler}*N)+${cy})':
    cb='cb((X-${cx})/(1+${scaler}*N)+${cx}, (Y-${cy})/(1+${scaler}*N)+${cy})',
setsar=1:1,
zscale=
    rin=full:
    r=full
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

. $(dirname "$0")/review.sh "${1%.*}-zoom.nut"
