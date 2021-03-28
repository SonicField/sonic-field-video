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
$(dirname "$0")/ffmpeg -y \
    -i "$1"\
    -c:v libx264 \
    -crf 9 \
    -qp 9 \
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
format=gbrpf32le,
zscale=
    rin=full:
    r=full:
    npl=100:
    dither=none:
    f=point:
    t=linear,
tonemap=linear:
    param=0.25:
    desat=0,
zscale=
    rin=full:
    r=full:
    c=left:
    m=bt709:
    p=bt709:
    t=bt709
" ${1%.*}-youtube-bt709.mp4

