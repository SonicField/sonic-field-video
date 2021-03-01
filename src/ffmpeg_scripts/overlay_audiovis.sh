#!/bin/zsh
# Description:
# Creates an visualization of audio.ng
#
# Args:
# <video/audio in name> <background image>
#
# Out:
# <*-ovaudio-vis>.nut
#

. $(dirname "$0")/encoding.sh

# First get a wav file of the correct samples.
${exe} -y -i "${1}" -filter_complex '[0:a]aresample=24000[a]' -map '[a]' tempa.wav

# looping and image seems to run for ever even with -shortest!
len=$($(dirname "$0")/get_length.sh "${1}")
cmd="${exe} -y -i tempa.wav -i '${2}' ${enc} -to ${len} -filter_complex \"
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
    size=1920x540,
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
colorkey=
    color=black,
hue=
    H=t,
split=2
[x1][x2];

[x1]
vflip
[x3];

[x2][x3]
vstack
[v1];

[1:v]
loop=
    loop=-1:
    size=32767:
    start=0,
loop=
    loop=-1:
    size=32767:
    start=0,
fps=${r},
scale=
    size=1920x1080:
    flags=lanczos,
setsar=1:1
[img];

[img][v1]
overlay
[v]
\" -map '[v]' tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i tempv.nut -i '${1}' ${enc} -map 0:v -map 1:a '${1%.*}-ovaudio-vis.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
