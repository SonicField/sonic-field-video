#!/bin/zsh

# Description:
# Produce youtube output
#
# Args:
# <video in>
#
# Out:
# <*-youtube-x265.mp4
#
# Notes to explane mappings.
# ==========================
# 
# At the moment I have not figured out how to convert the transfer from linear to smpte2084
# using a built in library so am usng a custom settup with curves to regrade the incoming video
# to smtpe HLG which is not perfect.
#
# The correct soloution is to do the change with a correctly created converter - I have a gut feeling
# there must be a way using zscale - I've just not found it yet. If it requires a C code change then
# I'll send that back to the community.
#
# For youtube the NPL - nominal peak luminance is important and a value to 200 seems about right
# which is odd because the standard is 1000 but I think youtube is using this to figure out how
# to scale the brightness to stream corectly and setting it higher just washes out the highlights.
#

zmodload zsh/mathfunc

green="G($((int(0.17/0.00002))),$((int(0.797/0.00002))))"
red="R($((int(0.708/0.00002))),$((int(0.292/0.00002))))"
blue="B($((int(0.313/0.00002))),$((int(0.046/0.00002))))"
whpt="WP($((int(0.3127/0.00002))),$((int(0.3290/0.00002))))"
luma="L(10000000,1)"
master="${green}${blue}${red}${whpt}${luma}"
echo "MASTERING: ${master}"

$(dirname "$0")/ffmpeg -y \
    -i "$1"\
    -c:v libx265 \
    -x265-params \
       "repeat-headers=1:hdr-opt=1:colorprim=bt2020:transfer=smpte2084:colormatrix=bt2020nc:master-display=${master}:max-cll=500,200:hdr10=1:dhdr10-info=metadata.json" \
    -crf 15 \
    -preset medium \
    -c:a aac \
    -b:a 256k \
    -pix_fmt yuv444p12le \
    -r 25 \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    -colorspace bt2020nc \
    -color_primaries bt2020 \
    -color_trc smpte2084 \
    -color_range 2 \
    -chroma_sample_location left \
    -fflags +igndts \
    -fflags +genpts \
    -vf "
zscale=in_range=full:out_range=full,
format=gbrpf32le,
zscale=
    t=linear,
tonemap=linear:
    param=1.0:
    desat=0,
zscale=
    npl=175:
    rin=full:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
    r=full
" ${1%.*}-youtube-smpte2084.mkv

