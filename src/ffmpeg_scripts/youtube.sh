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
    -c:v libx265 -preset medium \
    -crf 15 \
    -tune grain \
    -c:a aac \
    -b:a 256k \
    -pix_fmt yuv420p \
    -r 25\
    -sws_flags +accurate_rnd+full_chroma_int \
    -colorspace 1 \
    -color_primaries 1 \
    -color_trc 1 \
    -color_range 1 \
    -vf '
scale=
    size=3840x2160:
    flags=lanczos,
zscale=
    rangein=full:
    range=limited,
format=yuv420p
' \
    "${1%.*}-youtube.mp4"
 
