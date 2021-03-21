#!/bin/zsh

# Description:
# Play a video for review

. $(dirname "$0")/encoding.sh

font_file=$(dirname "$0")/Arial-Unicode.ttf
$(dirname "$0")/ffplay -threads 16 -vf "
format=gbrpf32le,
zscale=
    npl=250:
    size=1920x1080:
    dither=none:
    f=point:
    t=linear,
tonemap=linear:
    param=1.0:
    desat=0,
zscale=
    m=bt709:
    p=bt709:
    t=bt709,
drawtext=
    fontfile=${font_file}:
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
