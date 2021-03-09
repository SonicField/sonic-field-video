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
   size=560x560,
boxblur=
    0:0:0:0:3:1,
fps=${r},
pad=
   x=20:
   y=20:
   h=600:
   w=600:
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
    size=1920x1080,
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
    w=15:
    h=0:
    t=1:
    replace=1:
    c=0x00000000,
hue=
    H=t,
format=rgba
[vb];

[vb][img]
overlay=
    eval=frame:
    x=660-cos(t/3)*300:
    y=80:
    format=rgb,
split=2
[vp][v2];

[vp]
drawbox=
    x=1:
    y=1:
    w=1920:
    h=1080:
    t=2:
    c=black,
format=rgba,
split=3
[v1][v3][v8];

[v1]
format=yuv444p12le,
perspective=
    interpolation=cubic:
    sense=destination:
    x0=925:
    y0=520:
    x1=1920:
    y1=520:
    x2=0:
    y2=1080:
    x3=1920:
    y3=1080,
gradfun,
curves=
    all='0/0 1/0.25',
eq=
   saturation=0.5,
colorkey=
    color=black:
    similarity=0.01:
    blend=0,
scale=
    size=3840x2160:
    flags=lanczos
[v4];

[v3]
format=yuv444p12le,
perspective=
    interpolation=cubic:
    sense=destination:
    x0=0:
    y0=0:
    x1=925:
    y1=0:
    x2=0:
    y2=1080:
    x3=925:
    y3=520,
gradfun,
curves=
    all='0/0 1/0.25',
eq=
   saturation=0.5,
scale=
    size=3840x2160:
    flags=lanczos
[v5];

[v8]
format=yuv444p12le,
perspective=
    interpolation=cubic:
    sense=destination:
    x0=925:
    y0=0:
    x1=1920:
    y1=0:
    x2=925:
    y2=520:
    x3=1920:
    y3=520,
gradfun,
curves=
    all='0/0 1/0.25',
eq=
   saturation=0.5,
colorkey=
    color=black:
    similarity=0.01:
    blend=0,
scale=
    size=3840x2160:
    flags=lanczos
[v9];

[v2]
scale=
    size=3840x2160:
    flags=lanczos,
format=rgba
[v6];

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
eq=
    saturation=1.2,
gradfun=
    strength=8:
    radius=4,
curves=
    r='0/0 0.01/0.001 0.07/0.020  0.5/0.57 1/1':
    g='0/0 0.01/0.001 0.07/0.018  0.5/0.4  1/1':
    b='0/0 0.01/0.001 0.07/0.022  0.5/0.6  1/1'
[v]
\" -map '[v]' tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i tempv.nut -i '${1}' ${enc} -map 0:v -map 1:a '${1%.*}-audio-vis.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm tempv.nut

