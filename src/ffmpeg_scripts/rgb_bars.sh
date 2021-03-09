#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# Create a pixel bare map of rgb for chrome subsampling invstigation
#
# Out:
# <rgb-bars>.nut
#

font_file=$(dirname "$0")/Arial-Unicode.ttf
. $(dirname "$0")/encoding.sh
cmd="${exe} -to 10 ${enc} -filter_complex \"
color=
    size=80x135:
    r=${r}:
    c=black,
format=rgb24,
geq=
r='eq(mod(X,3), 0) * 255':
g='eq(mod(X,3), 1) * 255':
b='eq(mod(X,3), 2) * 255',
split=3
[vi1][vi2][vi3];

[vi1]
format=yuv420p,
format=yuv444p
[v1];

[vi2]
format=yuv422p,
format=yuv444p
[v2];

[vi3]
format=yuv444p
[v3];

[v1][v2][v3]
hstack=3,
scale=
    size=1920x1080:
    flags=neighbor,
drawtext=
    fontfile=${font_file}:
    text='YUV420p':
    fontsize=64:
    x=5:
    y=5:
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black,
drawtext=
    fontfile=${font_file}:
    text='YUV422p':
    fontsize=64:
    x=5+640:
    y=5:
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black,
drawtext=
    fontfile=${font_file}:
    text='YUV444p':
    fontsize=64:
    x=5+640*2:
    y=5:
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black
[v]

\" -map '[v]' 'rgb-bars.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
