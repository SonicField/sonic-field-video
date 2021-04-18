#!/bin/zsh

# Description:
# Play a video for review at 1920x1080 but zoomed in.
# The output is 8 bit so it is closer to the SDR version
#
# Arguments
# =========
#
# <video> <x-position 0 to 1> <y position 0 to 1?

. $(dirname "$0")/encoding.sh
lut=$(get_lut luminance_-4p00)

${player} -threads 16 -fast -noframedrop -vf "
format=gbrp16le,
crop=
    out_w=in_w/2:
    out_h=in_h/2:
    x=in_w*0.5*${2}:
    y=in_h*0.5*${3},
zscale=
    rin=full:
    r=full:
    tin=smpte2084:
    min=2020_ncl:
    pin=2020:
    npl=3000:
    p=bt709:
    m=bt709:
    t=bt709:
    size=1920x1080
" -seek_interval 1.0 "${1}"

