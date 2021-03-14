#!/bin/zsh

# Description:
# Produce youtube output converted to bt709 from linear light.
# The output is in yuv42010le which seems a good compromise to send to
# youtube as I have no evidence youtube uses better then yuv420p.
#
# Compressions is x265 which gives the smallest file size for the best
# quality.  Moving crf down from 30 might make a difference but this seems
# about right in terms of internet upload speed compared to the compression
# youtube will then add.
#
# Fiddle with 'threads' for more cores, on my Mac Book Pro i9 8 is optimal;
# any more just heats up the CPU for no benefit as x265 takes most of the
# power anyhow.
#
# Args:
# <video in>
#
# Out:
# <*-youtube-bt709.mkv
#

zmodload zsh/mathfunc

$(dirname "$0")/ffmpeg -y \
    -v verbose \
    -i "$1"\
    -c:v libx265 \
    -crf 18 \
    -preset medium \
    -c:a aac \
    -b:a 128k \
    -pix_fmt yuv420p \
    -r 25 \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    -colorspace bt709 \
    -color_primaries bt709 \
    -color_trc linear \
    -color_range 2 \
    -chroma_sample_location left \
    -threads 8 \
    -vf "
scale=in_range=full:out_range=full,
format=yuv420p10le
" \
${1%.*}-youtube-linear.mkv

