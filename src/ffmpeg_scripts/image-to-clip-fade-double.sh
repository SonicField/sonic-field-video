#!/bin/zsh

# Description:
# Make and image into a clip and fade into and out from the image from a colour.
# The fade will be 0.25 seconds.
# 
# Args:
# <image> <seconds-lenght> <fade in from colour> <fade out to colour> <output>
#
# Out:
# <output>.nut

. ./$(dirname "$0")/encoding.sh
$(dirname "$0")/ffmpeg -i "$1" -t "$2" ${enc} -filter_complex  \
"
[0:v]
loop=
    loop=-1:
    start=0:
    size=$((${r}*${2})),
fps=25,
scale=1920x1080,
fade=
    t=in:
    st=0:
    d=0.25:
    c=${3},
fade=
    t=out:
    st=$((${2}-0.25)):
    d=0.25:
    c=${4},
setsar=1:1,
fps=25
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
" \
 -map "[v]" -map "[a]" \
 "${5}.nut"
