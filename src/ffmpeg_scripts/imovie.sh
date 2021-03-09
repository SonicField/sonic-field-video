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
    -qscale:v 5 \
    -vendor apl0 \
    -pix_fmt yuv422p10le \
    -r 25 \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    -color_range 1 \
    -colorspace bt2020nc \
    -color_primaries bt2020 \
    -color_trc smpte2084 \
    -vf '
zscale=
    size=3840x2160:
    d=error_diffusion:
    f=lanczos:
    rangein=full:
    range=limited
'  \
    "${1%.*}-imovie.mov"
