#!/bin/zsh

# Description:
# Produce youtube output
#
# Args:
# <video in>
#
# Out:
# <*-youtube-bt709.mkv
#


zmodload zsh/mathfunc

# Get r!
. $(dirname "$0")/encoding.sh
lut=$(get_lut luminance_-1p00)
$(dirname "$0")/ffmpeg -y \
    -i "$1"\
    -c:v libx264 \
    -crf 9 \
    -preset medium \
    -c:a aac \
    -b:a 256k \
    -pix_fmt yuv420p \
    -r ${r} \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    -colorspace bt709 \
    -color_primaries bt709 \
    -color_trc bt709 \
    -color_range 2 \
    -chroma_sample_location left \
    -fflags +igndts \
    -fflags +genpts \
    -vf "
format=gbrp16le,
zscale=
    r=full:
    npl=3000:
    p=bt709:
    m=bt709:
    t=bt709:
    rin=full
" ${1%.*}-youtube-bt709.mp4

