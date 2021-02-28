#!/bin/bash
$(dirname "$0")/ffmpeg -i $1 -vcodec libx264 -crf 1.0 -x264opts keyint=12 -preset medium -c:a pcm_s32le -ar 96K -filter_complex \
'
[0:a]
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
    1920x1080[spect],
fps=50
[v]' \
 -map "[v]" -map 0:a \
"${2}.nut"
