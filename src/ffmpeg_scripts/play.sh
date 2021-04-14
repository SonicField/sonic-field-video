#!/bin/zsh

# Description:
# Play a video for review.
# The output is 8 bit so it is closer to the SDR version
# The scaling factor of 1/4 is the 4000->1000 nit conversion factor
# still working on exactly what that is all about.

. $(dirname "$0")/encoding.sh
lut=$(get_lut luminance_-4p00)

${player} -threads 16 -fast -vf "
format=gbrp16le,
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
    size=1920x1080,
drawtext=
    fontfile='${font_file}':
    text='%{n} %{pts\:hms}':
    fontsize=32:
    x=(w-tw)/2:y=h-(2*lh):
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black
" -seek_interval 1.0 "${1}"

#rm temp_v.avi 2>/dev/null
