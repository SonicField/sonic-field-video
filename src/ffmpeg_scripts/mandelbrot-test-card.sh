#!/bin/zsh
#
# Description:
# Create a 10 second mandelbrot test card @ 4k r fps
#
# Args:
# <time in seconds>
#
# Out:
# <test-card-<len>>.nut

. $(dirname "$0")/encoding-4k.sh
font_file=$(dirname "$0")/Arial-Unicode.ttf
cmd="${exe} ${enc} -to ${1} -filter_complex \"
mandelbrot=
    r=${r}:
    size=1920x1080:
    start_scale=0.001:
    end_scale=0.0001,
split=4
[tl][tr0][bl0][br0];

[tr0]
hue=
    s=0
[tr];

[bl0]
format=yuv444p,
hue=
   H=PI*t,
rotate=
   angle=t/5,
lagfun=
    decay=0.9,
drawgrid=
    width=17:
    height=17:
    thickness=1:
    color=invert
[bl];

[br0]
negate,
drawgrid=
    width=16:
    height=16:
    thickness=1:
    color=invert,
normalize
[br];

color=
    r=${r}:
    size=3840x2160:
    c=black
[bg];

[bg][tl]
overlay=
    x=0:
    y=0
[v1];

[v1][tr]
overlay=
    x=1920:
    y=0
[v2];

[v2][bl]
overlay=
    x=0:
    y=1080
[v3];

[v3][br]
overlay=
    x=1920:
    y=1080,
drawtext=
    fontfile=${font_file}:
    text='%{n} %{pts\:hms}':
    fontsize=64:
    x=5:
    y=5:
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow,
drawtext=
    fontfile=${font_file}:
    text='© Dr Alexander J. Turner 2021 - Creative Commons Attribution':
    fontsize=48:
    x=(w-tw)/2:y=h-(2*lh):
    fontcolor=white:
    bordercolor=black:
    borderw=2
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' 'test-card-${1}.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
