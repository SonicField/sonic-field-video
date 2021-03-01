#!/bin/zsh
# Description:
# Creates an visualization of audio.ng
#
# Args:
# <video/audio in name> 
#
# Out:
# <*-audio-vis>.nut
#

. $(dirname "$0")/encoding.sh

# First get a wav file of the correct samples.
${exe} -y -i "${1}" -filter_complex '[0:a]aresample=24000[a]' -map '[a]' tempa.wav

cmd="${exe} -y -i tempa.wav ${enc} -shortest -filter_complex \"
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
split=2
[v1][v2];

[v1]
drawbox=
    x=1:
    y=1:
    w=1919:
    h=1079:
    t=2:
    c=black,
perspective=
    sense=destination:
    x0=960+400:
    y0=250:
    x1=1920+100:
    y1=250:
    x2=0:
    y2=1080:
    x3=1920:
    y3=1080,
curves=
    all='0/0 1/0.25',
eq=
   saturation=0.5
[v3];

[v3]
scale=
    size=3840x2160
[v4];

[v2]
scale=
    size=3840x2160
[v5];

[v4][v5]
overlay,
scale=
    s=1920x1080:
    flags=lanczos,
hue=
    H=t,
unsharp
[vis];

[0:v]
loop=
    loop=-1:
    start=0:
    size=$((${r}*${2})),
fps=${r},
scale=
    size=1920x1080:
    flags=lanczos,
setsar=1:1
[v];
\" -map '[v]' tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
#. ./run.sh

cmd="${exe} -i tempv.nut -i '${1}' ${enc} -map 0:v -map 1:a '${1%.*}-audio-vis.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
