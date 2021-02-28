#!/bin/zsh
# Description:
# Make a rotating visualizatio of audio
#
# Args:
# <video or audio in> <overlay pnh> <horrizonal position>
#
# Out:
# <*-pannel>.nut
#
#
len=$($(dirname "$0")/get_length.sh "${1}")
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' ${enc} -ss 0 -to ${len} -filter_complex \
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
fps=${r}
[img];

ahistogram=
    scale=lin:
    rate=${r}:
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
[cmp];

[cmp][img]
overlay=
    x=340:
    y=340,
fade=
    t=in:
    st=0:
    c=black:
    d=0.5,
fade=
    t=out:
    st=$((${len}-0.5)):
    c=black:
    d=0.5
[vr];

color=
    c=0x00000000:
    s=1920x1080:
    r=${r} 
[c];

[c][vr]
overlay=
    x=${3}:
    y=0
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

$(dirname "$0")/ffmpeg -i "${1}" -c:a pcm_s32le -ar 96K tempa.wav

export cmd="${exe} -i tempa.wav -i tempv.nut ${enc} -map 1:v -map 0:a '${1%.*}-pannel.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm tempv.nut
rm tempa.wav
