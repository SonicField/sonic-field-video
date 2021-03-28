#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# Create a pixel bare map of rgb for chrome subsampling invstigation at fine bar size
#
# Out:
# <rgb-fine-bars>.nut
#

font_file=$(dirname "$0")/Arial-Unicode.ttf
. $(dirname "$0")/encoding.sh
cmd="${exe} -to 10 ${bt709_enc} -filter_complex \"
color=
    size=1280x2160:
    r=${r}:
    c=black,
format=rgb24,
scale=in_range=full:out_range=full,
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
    x=5+640*2:
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
    x=5+640*4:
    y=5:
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black
[v]

\" -map '[v]' 'rgb-fine-bars.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
