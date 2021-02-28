#!/bin/zsh
# Description:
# Make a rotating visualization of audio in a 1080 square for embedding.
#
# Args:
# <video or audio in> <overlay png>
#
# Out:
# <*-square>..nut
#

. $(dirname "$0")/encoding.sh

# Bigger z_rate slows down the 'cube' rotation.
z_rate=$((${r} * 3))
len=$($(dirname "$0")/get_length.sh "${1}")
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
[box];

[box][img]
overlay=
    x=340:
    y=340
[vr];

color=
    c=black:
    s=1080x1080:
    r=${r}
[c];

[c][vr]
overlay,
drawbox=
    width=1080:
    height=1080:
    thickness=1:
    color=0x00000000:
    replace=1:
    x=0:
    y=0,
split=4
[squ1][squ2][squ3][squ4];

[squ1]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/${z_rate}) * 763':
    y0=' 25 + sin(on/${z_rate} + PI*0.5) * 25':

    x2=' 540 + sin(on/${z_rate}) * 763':
    y2='1055 - sin(on/${z_rate}+PI*0.50) * 25':

    x1='540 + sin(on/${z_rate} + PI*0.5) * 763':
    y1=' 25 + sin(on/${z_rate} + PI*1.0) * 25':

    x3=' 540 + sin(on/${z_rate} + PI*0.5) * 763':
    y3='1055 - sin(on/${z_rate} + PI*1.0) * 25',
colorlevels=
    aomax=0.9
[squ_1];

[squ2]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/${z_rate} + PI*0.5) * 763':
    y0=' 25 + sin(on/${z_rate} + PI*0.5 + PI*0.5) * 25':

    x2=' 540 + sin(on/${z_rate} + PI*0.5) * 763':
    y2='1055 - sin(on/${z_rate} + PI*0.5 + PI*0.5) * 25':

    x1='540 + sin(on/${z_rate} + PI*0.5 + PI*0.5) * 763':
    y1=' 25 + sin(on/${z_rate} + PI*1.0 + PI*0.5) * 25':

    x3=' 540 + sin(on/${z_rate} + PI*0.5 + PI*0.5) * 763':
    y3='1055 - sin(on/${z_rate} + PI*1.0 + PI*0.5) * 25',
colorlevels=
    aomax=0.9
[squ_2];

[squ3]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/${z_rate} + PI*1.0) * 763':
    y0=' 25 + sin(on/${z_rate} + PI*0.5 + PI*1.0) * 25':

    x2=' 540 + sin(on/${z_rate} + PI*1.0) * 763':
    y2='1055 - sin(on/${z_rate} + PI*0.5 + PI*1.0) * 25':

    x1='540 + sin(on/${z_rate} + PI*0.5 + PI*1.0) * 763':
    y1=' 25 + sin(on/${z_rate} + PI*1.0 + PI*1.0) * 25':

    x3=' 540 + sin(on/${z_rate} + PI*0.5 + PI*1.0) * 763':
    y3='1055 - sin(on/${z_rate} + PI*1.0 + PI*1.0) * 25',
colorlevels=
    aomax=0.9
[squ_3];

[squ4]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/${z_rate} + PI*1.5) * 763':
    y0=' 25 + sin(on/${z_rate} + PI*0.5 + PI*1.5) * 25':

    x2=' 540 + sin(on/${z_rate} + PI*1.5) * 763':
    y2='1055 - sin(on/${z_rate} + PI*0.5 + PI*1.5) * 25':

    x1='540 + sin(on/${z_rate} + PI*0.5 + PI*1.5) * 763':
    y1=' 25 + sin(on/${z_rate} + PI*1.0 + PI*1.5) * 25':

    x3=' 540 + sin(on/${z_rate} + PI*0.5 + PI*1.5) * 763':
    y3='1055 - sin(on/${z_rate} + PI*1.0 + PI*1.5) * 25',
colorlevels=
    aomax=0.9
[squ_4];

[squ_1][squ_2]
overlay
[ov1];

[squ_3][squ_4]
overlay
[ov2];

[ov2][ov1]
overlay,
drawbox=
    width=1078:
    height=1078:
    thickness=1:
    color=0x00FF0088:
    replace=1:
    x=1:
    y=1,
drawbox=
    width=1080:
    height=1080:
    thickness=1:
    color=0x00880000:
    replace=1:
    x=0:
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

export cmd="${exe} -i tempa.wav -i tempv.nut -c:v copy -c:a aac -b:a 256k -map 1:v -map 0:a '${1%.*}-square.mp4'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm tempv.mp4
rm tempa.wav
