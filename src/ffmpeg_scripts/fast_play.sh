#!/bin/zsh

# Description:
# Play a video for review.
# Plays the review output

. $(dirname "$0")/encoding.sh

$(dirname "$0")/ffplay -threads 16 -fast -seek_interval 1.0 "view.mov"
