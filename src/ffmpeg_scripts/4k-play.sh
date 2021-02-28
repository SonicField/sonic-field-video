#!/bin/zsh

# Description:
# Play a video for review

. $(dirname "$0")/encoding.sh
font_file=$(dirname "$0")/Arial-Unicode.ttf
$(dirname "$0")/ffplay -vf "
drawtext=
    fontfile=${font_file}:
    text='%{n} %{pts\:hms}':
    fontsize=64:
    x=(w-tw)/2:y=h-(2*lh):
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black
    " -seek_interval 1.0 -fast "${1}"
#rm temp_v.avi 2>/dev/null
