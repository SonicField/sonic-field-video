#!/bin/zsh

# Description:
# Produce youtube output
#
# Args:
# <video in> <audio in> <output>
#
# Out:
# <*-finalized>.mp4

$(dirname "$0")/ffmpeg -y -i "$1" \
    -c:v libx264 -preset medium \
    -crf 15 \
    -tune film \
    -c:a aac \
    -b:a 256k \
    -pix_fmt yuv444p10le \
    -r 25\
    -sws_flags +accurate_rnd+full_chroma_int \
    -colorspace 1 \
    -color_primaries 1 \
    -color_trc 1 \
    -dst_range 1 \
    -color_range 1 \
    -vf '
zscale=
    rangein=full:
    range=limited
' \
    "${1%.*}-finalized.mp4"
 
