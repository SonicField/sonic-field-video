#!/bin/zsh

# Description:
# Play a video for review

. $(dirname "$0")/encoding.sh
font_file=$(dirname "$0")/Arial-Unicode.ttf
$(dirname "$0")/ffplay -x 1920 -y 1080 -vf "
scale=1920x1080:
    flags=neighbor,
drawtext=
    fontfile=${font_file}:
    text='%{n} %{pts\:hms}':
    fontsize=64:
    x=(w-tw)/2:y=h-(2*lh):
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black,
format=yuv444p12le,
tonemap=clip,
zscale=
    f=lanczos:
    tin=linear:
    range=full:
    t=bt709:
    c=left:
    p=bt709:
    m=bt709'
" -seek_interval 1.0 -fast -infbuf -noframedrop "${1}"
