#!/bin/zsh

# Description:
# Produce youtube output
#
# Args:
# <video in> <audio in> <output>
#
# Out:
# <output>.mp4

$(dirname "$0")/ffmpeg -y -i "$1" -c:v libx264 -b:v 512K -c:a aac -b:a 256k -pix_fmt yuv420p "$2.mp4"
