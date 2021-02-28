#!/bin/zsh
# Compute the length of a video to exactly the last frame
. $(dirname "$0")/encoding.sh
fd=`$(dirname "$0")/ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${1}" `
#fd=$(( $fd + $( fps_round $((1. / ${r})) ) ))
echo $( fps_round $fd )
