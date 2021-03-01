#!/bin/zsh
# Description:
# Make a rotating visualization of audio for direct upload to youtube.
# The output is not in lossless full range - so do not expect it to be perfect is
# further post processing is use.
#
# Args:
# <video or audio in> <overlay png>
#
# Out:
# <*-music-video>.mp4
#

len=$($(dirname "$0")/get_length.sh "${1}")
exe="$(dirname "$0")/ffmpeg"

# Notes on encoding:
# ==================
# - Youtube uses yuv420p so no point trying for something better here.
# - We could use 4K upscaling to make a nicer video - but the point is music.
# - Youtube uses 'tv' color range so we output to that to avoid Youtube converting it.
# - Youtube will crush the quality anyhow so -crf 18 is probaby OK...
# - Audio is encoding into 256k aac for the final product (which should be good enough).
#
# Notes on intermediate filles:
# =============================
# - For simplicity this makes tempv.mp4 and tempa.wav (32bit integer 96k) then moshes them
#   together to form the final file and removes the intermediate.
# - The main video script is written to run.sh and then executed; this really helps with debugging.:w
#
# Notes on performance:
# =====================
# - My MBP encodes this at a leisurely 10 fps and gets very hot doing it.
# - One trick is to add -threads 1 to the command line and just leave it running over night.
# - Alternatively - work on streamlining the filters.

enc="-c:v libx264 -preset medium -tune film -crf 18 -s 1920x1080 -sar 1:1 -r 50 -pix_fmt yuv420p -sws_flags +accurate_rnd+full_chroma_int -colorspace 1 -color_primaries 1 -color_trc 1 -dst_range 1 -color_range 1"

cmd="${exe} -y -i '${1}' -i '${2}' ${enc} -ss 0 -to ${len} -filter_complex \
\"
[1:v]
loop=
    loop=-1:
    start=0:
    size=${len},
scale=
   size=400x400:
   flags=lanczos,
boxblur=
    0:0:0:0:3:1,
fps=50
[img];

ahistogram=
    scale=lin:
    rate=50:
    ascale=log:
    acount=-0.5:
    slide=scroll:
    size=1080x1080,
tmix=
    frames=10,
colorkey=
    color=black:
    similarity=0.01:
    blend=0,
format=rgba,
split=3
[v1][v2][v3];

[v1]
rotate=
    bilinear=0:
    angle=PI/3.0,
colorlevels=
    gomax=0
[vr1];

[v2]
rotate=
    bilinear=0:
    angle=-PI/3.0,
colorlevels=
    romax=0
[vr2];

[v3]
rotate=
    bilinear=0:
    angle=PI,
colorlevels=
    bomax=0
[vr3];

[vr1][vr2][vr3]
mix=
    inputs=3,
curves=
   red=  '0/0 0.4/0.7 1/1':
   green='0/0 0.4/0.7 1/1':
   blue= '0/0 0.4/0.7 1/1',
colorkey=
   color=black,
drawbox=
    width=1080:
    height=1080:
    thickness=2:
    color=white:
    replace=1:
    x=0:
    y=0,
rotate=
   angle=t/12:
   fillcolor=0x000088:
   bilinear=0,
gblur=
    sigma=1,
drawbox=
    width=1080:
    height=1080:
    thickness=3:
    color=white:
    replace=1:
    x=0:
    y=0
[box];

[box][img]
overlay=
    x=340:
    y=340
[vr];

color=
    c=black:
    s=1920x1080:
    r=50 
[c];

[c][vr]
overlay=
    x=420:
    y=0,
lagfun=
    decay=0.99,
format=yuv444p12le,
rotate=
   angle=-PI * 2 * sin(t/24):
   fillcolor=0x00000000:
   bilinear=0,
lagfun=
    decay=0.99
[out];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[out]' -map '[a]' tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

$(dirname "$0")/ffmpeg -y -i "${1}" -c:a pcm_s32le -ar 96K tempa.nut

export cmd="${exe} -i tempa.nut -i tempv.nut -c:v copy -c:a aac -b:a 256k -map 1:v -map 0:a '${1%.*}-music-video.mp4'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm tempv.nut
rm tempa.nut
