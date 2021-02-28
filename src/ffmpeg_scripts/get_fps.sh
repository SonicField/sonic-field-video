#!/bin/zsh
ot=$( $(dirname "$0")/ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate "${1}" )
echo ${ot}
