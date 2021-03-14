#!/bin/zsh
# Description:
# Creates an visualization of audio.ng
#
# Args:
# <video/audio in name> <logo>
#
# Out:
# <*-audio-vis>.nut
#

len=$($(dirname "$0")/get_length.sh "${1}")

. $(dirname "$0")/encoding.sh

# First get a wav file of the correct samples.
${exe} -y -i "${1}" -filter_complex '[0:a]aresample=24000[a]' -map '[a]' tempa.wav

cmd="${exe} -y -i tempa.wav  -i logo-alpha.png ${enc} -shortest -to '${len}' -filter_complex \"
[1:v]
format=rgba,
loop=
    loop=-1:
    start=0:
    size=${len},
scale=
   size=1120x1120,
boxblur=
    0:0:0:0:3:1,
fps=${r},
pad=
   x=40:
   y=40:
   h=1200:
   w=1200:
   color=0x00000000,
rotate=
    bilinear=1:
    fillcolor=0x00000000:
    angle=-PI * 2 * sin(t/10),
tmix=
   frames=12:
   weights='12 0.5',
geq=
r='r(X,Y)':
g='g(X,Y)':
b='b(X,Y)':
a='gt(alpha(X,Y),80)*pow(alpha(X,Y)/255,2)*alpha(X,Y)',
format=rgba
[img];


[0:a]
highpass=
    f=1,
acompressor=
    level_in=8:
    threshold=0.125:
    detection=peak:
    ratio=4,
acompressor=
    level_in=16:
    threshold=0.25:
    detection=peak:
    ratio=4,
volume=2.0,
showfreqs=
    colors=cyan|magenta:
    mode=bar:
    fscale=lin:
    ascale=lin:
    win_size=256:
    size=3840x2160,
lagfun=
    decay=0.99:
    planes=1,
fps=${r},
format=rgba,
colorkey=
    color=0x00000000:
    similarity=0.01:
    blend=0,
drawgrid=
    w=30:
    h=0:
    t=2:
    replace=1:
    c=0x00000000,
hue=
    H=t,
format=rgba
[vb];

[vb][img]
overlay=
    eval=frame:
    x=1320-cos(t/3)*600:
    y=160:
    format=rgb,
split=2
[vp][v6];

[vp]
drawbox=
    x=1:
    y=1:
    w=3840:
    h=2160:
    t=2:
    c=black,
format=rgba,
split=3
[v1][v3][v8];

[v1]
format=yuv444p12le,
perspective=
    sense=destination:
    x0=1850:
    y0=1040:
    x1=3840:
    y1=1040:
    x2=0:
    y2=2160:
    x3=3840:
    y3=2160,
eq=
   saturation=0.5,
curves=
    all='0/0 1/0.25',
gradfun,
colorkey=
    color=black:
    similarity=0.01:
    blend=0
[v4];

[v3]
format=yuv444p12le,
perspective=
    sense=destination:
    x0=0:
    y0=0:
    x1=1850:
    y1=0:
    x2=0:
    y2=2160:
    x3=1850:
    y3=1040,
eq=
   saturation=0.5,
curves=
    all='0/0 1/0.25',
gradfun
[v5];

[v8]
format=yuv444p12le,
perspective=
    sense=destination:
    x0=1850:
    y0=0:
    x1=3840:
    y1=0:
    x2=1850:
    y2=1040:
    x3=3840:
    y3=1040,
eq=
   saturation=0.5,
curves=
    all='0/0 1/0.25',
gradfun,
colorkey=
    color=black:
    similarity=0.01:
    blend=0
[v9];

[v5][v4]
overlay=
    format=rgb
[v7];

[v7][v9]
overlay=
    format=rgb
[v10];

[v10][v6]
overlay=
    format=rgb,
colorkey=
    color=black:
    similarity=0.01:
    blend=0
[top];

color=
    size=3840x2160:
    color=black
[bottom];

[bottom][top]
overlay=
    format=rgb,
format=yuv444p12le,
scale=
    in_range=limited:
    out_range=full,
eq=
    saturation=1.2,
gradfun=
    strength=8:
    radius=4
[v]
\" -map '[v]' tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i tempv.nut -i '${1}' -c:v copy -c:a pcm_s32le -ar 96K -map 0:v -map 1:a '${1%.*}-audio-vis.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

