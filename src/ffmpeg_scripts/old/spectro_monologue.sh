#!/bin/zsh
$(dirname "$0")/ffmpeg -i "$1" -vcodec libx264 -crf 1.0 -x264opts keyint=12 -preset medium -c:a pcm_s32le  -filter_complex \
'
[0:a]showspectrum=
    s=1536x864:
    legend=true:
    mode=combined:
    slide=rscroll:
    saturation=2.0:
    data=magnitude:
    scale=log:
    color=rainbow:
    fscale=log,
scale=
    1920x1080[spect];

[0:v]
scale=
    1536:864,
unsharp=
    luma_msize_x=7:
    luma_msize_y=7:
    luma_amount=1.0:
    chroma_msize_x=9:
    chroma_msize_y=9:
    chroma_amount=1,
colorkey=
    0x00FF00:0.4:0.0,
despill=
   green=-1,
boxblur=
    0:0:0:0:3:2[ckv_out];

[spect][ckv_out]overlay=
    x=192:
    y=216,
fps=50,
setsar=1:1
[v]' \
 -map '[v]' -map a:0 \
 "${2}.nut"

