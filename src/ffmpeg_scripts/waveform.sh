#!/bin/zsh

# Description:
# Play a video for review

. $(dirname "$0")/encoding.sh

font_file=$(dirname "$0")/Arial-Unicode.ttf
$(dirname "$0")/ffplay -x 1920 -y 1080 -i "${1}" -vf "
waveform=
    c=1:
    m=column:
    e=peak:
    f=color:
    d=2:
    g=orange,
drawtext=
    fontfile=${font_file}:
    text='%{n} %{pts\:hms}':
    fontsize=32:
    x=(w-tw)/2:y=h-(2*lh):
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black,
scale=
    size=1920x1080
" -seek_interval 1.0 

