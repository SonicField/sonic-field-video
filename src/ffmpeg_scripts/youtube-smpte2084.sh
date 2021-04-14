#!/bin/zsh

# Description:
# Produce youtube output
#
# Args:
# <video in>
#
# Out:
# <*-youtube-smpte2084.mkv
#

# To take advantage of the full bit depth of the piple line we normally work at about +4 stops.
# So this script drops 4 stops on output. This works will with a 500 nit display.
# These numbers will need tweaking for different matering displays.

zmodload zsh/mathfunc

# My Mac screen at max bightness
# master_pl=500
# The value normally used - stick with this for now.
master_pl=500
# Compute the meta date value for it.
master_pl=$((${master_pl} *  10000))

# Mastering values based on Rec2020
green="G($((int(0.17/0.00002))),$((int(0.797/0.00002))))"
red="R($((int(0.708/0.00002))),$((int(0.292/0.00002))))"
blue="B($((int(0.313/0.00002))),$((int(0.046/0.00002))))"
whpt="WP($((int(0.3127/0.00002))),$((int(0.3290/0.00002))))"
luma="L(${master_pl},1)"
master="${green}${blue}${red}${whpt}${luma}"

# Guess - need to figure out how to compute this.
max_cll='0,0'

. $(dirname "$0")/encoding.sh
lut=$(get_lut luminance_-4p00)
$(dirname "$0")/ffmpeg -y \
    -i "$1"\
    -c:v libx265 \
    -x265-params \
       "repeat-headers=1:hdr-opt=1:colorprim=bt2020:transfer=smpte2084:colormatrix=bt2020nc:master-display=${master}:max-cll=${max_cll}:hdr10=1:dhdr10-info=metadata.json" \
    -crf 5 \
    -preset medium \
    -c:a copy \
    -pix_fmt yuv422p12le \
    -r ${r} \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    -colorspace bt2020nc \
    -color_primaries bt2020 \
    -color_trc smpte2084 \
    -color_range 2 \
    -chroma_sample_location left \
    -fflags +igndts \
    -fflags +genpts \
    -vf "
zscale=
    rin=full:
    r=full,
format=gbrp16le,
lut3d=
    file='${lut}':
    interp=tetrahedral,
zscale=
    rin=full:
    r=full
" ${1%.*}-youtube-smpte2084.mkv

render_complete
