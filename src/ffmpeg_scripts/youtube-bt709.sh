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
    -i "$1"\
    -c:v libx265 \
    -x265-params \
       "repeat-headers=1:hdr-opt=1:colorprim=bt709:transfer=bt709:colormatrix=bt709" \
    -crf 18 \
    -preset medium \
    -c:a aac \
    -b:a 128k \
    -pix_fmt yuv420p10le \
    -r 25 \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    -colorspace bt709 \
    -color_primaries bt709 \
    -color_trc bt709 \
    -color_range 2 \
    -chroma_sample_location left \
    -threads 8 \
    -vf "
format=yuv444p12le,
curves=
    all='0/0 0.01/0.001 0.5/0.25 1/1',
tonemap=clip,
zscale=
    min=unspecified:
    f=lanczos:
    tin=linear:
    range=full:
    t=bt709:
    c=left:
    p=bt709:
    m=bt709" \
${1%.*}-youtube-bt709.mkv
