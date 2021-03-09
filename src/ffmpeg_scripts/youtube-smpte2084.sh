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
# The input to this converter is in linear light however its output needs to be
# in smpte2084/bt2020 for youtube to encode HDR.
# Even though the encoding pipeline is metadata marked as smpt 2084
# ffmpeg does not appear to be actually changing the color. Anyhow, this can be
# worked around by telling zscale to treat the import as linear and the output as
# smpte2084/bt2020. Then feed that into another zscale to upscale. The second one believes the
# first and passed through smpte 2084 and we are golden.
#
# Was that easy to figure out - no.
#
# Note that smtpe/bt2020 uses a strange hybride gamma and color system - trying to figure this
# out manually is sort of possible gamma wise but then red and blue are too dark. Be warned.
#
# Also - doing the conversions in yuv444p12le means the interpolation does not cause banding and we
# cleanly then drop down to yuv444p10le on output so the mapping does not cause any noticable
# degridation.
#
# The issue here is that at the time I was doing all this, HDR on youtube seems broken and all
# the input gets brightness squashed so peek white becomes 90% white. All in all I just gave
# up and went over to bt709.
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
       "repeat-headers=1:hdr-opt=1:colorprim=bt2020:transfer=smpte2084:colormatrix=bt2020nc:master-display=${master}:max-cll=1000,300:hdr10=1:dhdr10-info=metadata.json" \
    -crf 20 \
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
    -vf "
format=yuv444p12le,
zscale=
    tin=linear:
    transfer=linear,
zscale=
    f=lanczos:
    range=full:
    t=smpte2084:
    c=left:
    p=2020:
    m=2020_ncl
"  "${1%.*}-youtube-smpte2084.mkv"
