#!/bin/zsh

# Description:
# Pad an image and covert to a clip
# 
# Args:
# <image> <seconds-lenght> <size - 2 = 1080>
#
# Out:
# <*-image>.nut
#

size=$((960*${3}))x$((540*${3}))

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${enc} -ss 0 -to '${2}' -filter_complex \
\"
[0:v]
scale=in_range=full:out_range=full,
format=yuv444p16le,
loop=
    size=$((${r}*${2})):
    loop=-1:
    start=0,
pad='ih*16/9:ih:(ow-iw)/2:(oh-ih)/2',
$(image_ingest_bt2020 ${size}),
fps=${r},
setsar=1:1,
zscale=
    rin=full:
    r=full
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

. $(dirname "$0")/review.sh "${1%.*}-image.nut"
