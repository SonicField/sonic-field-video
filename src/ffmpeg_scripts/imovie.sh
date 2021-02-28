#!/bin/zsh

# Description:
# Produce imovie ingestable
#
# Args:
# <video in>
#
# Out:
# <*-imovie>.mov

$(dirname "$0")/ffmpeg -i "$1" \
    -c:v prores_ks \
    -profile:v 4 \
    -qscale:v 3 \
    -vendor apl0 \
    -pix_fmt yuv444p10le \
    -r 25 \
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
'  \
    "${1%.*}-imovie.mov"
