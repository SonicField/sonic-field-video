#!/bin/zsh
$(dirname "$0")/ffmpeg -i "$1" -i "$2" -vcodec libx264 -crf 1.0 -x264opts keyint=12 -preset medium -c:a flac -ar 96K -filter_complex \
'
[0:a]
afftdn=nf=-25,
bass=
    g=6:
    f=110:
    w=0.6[bass_l];

[1:a]
afftdn=nf=-25,
bass=
    g=6:
    f=110:
    w=0.6[bass_r];

[bass_l][bass_r]
join=
    inputs=2:
    channel_layout=stereo,
haas[stereo];

[0:a][1:a]
amix=
    inputs=2:
    duration=longest,
showspectrum=
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
format=rgba,
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
    0:0:0:0:3:2[ckv_left];

[1:v]
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
    0:0:0:0:3:2[ckv_right];

[spect][ckv_left]
overlay=
    x=-200:
    y=360[overlay_left];

[overlay_left][ckv_right]
overlay=
    x=760:
    y=360,
setsar=1:1
[video]' \
 -map '[video]' -map '[stereo]'\
 "${3}.nut"

