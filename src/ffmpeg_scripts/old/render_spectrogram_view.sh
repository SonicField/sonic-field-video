#!/bin/zsh

# Description:
# Convert a video into the wav/spectrogram view
#
# Args:
# <video in>
#
# Out:
# <*-spectrogram>.nut

# Setup environment
font_file=$(dirname "$0")/Arial-Unicode.ttf

# Create view
enc="$(dirname "$0")/encoding.txt"
enc="$(cat $enc)"
cmd="${exe} -i '${1}' ${enc} -filter_complex  '
amovie=${1}:
    s=dv+da
[v][a];

[a]
    asplit
[a0][out1];

[a0]
    asplit
[asp][aw];

[asp]
showspectrum=
    s=1536x864:
    legend=true:
    mode=combined:
    slide=rscroll:
    saturation=2.0:
    data=magnitude:
    scale=log:
    color=rainbow:
    fscale=log,
scale=
    1920x1080
[spec];

[aw]
showwaves=
    size=960x300:
    mode=line:
    split_channels=1:
    r=5:
    colors=0xFF8888|0x88FF88,
colorlevels=
    aomin=0.7,
scale=960x300
[wavs];

[v]
scale=960x540
[sv];

[spec][sv]
overlay=
    x=803:
    y=73,
drawbox=
    x=801:
    y=72:
    w=961:
    h=541:
    t=1:
    color=white
[ov1];

[ov1][wavs]
overlay=
    x=803:
    y=614,
drawbox=
    x=801:
    y=613:
    w=961:
    h=302:
    t=1:
    color=white,
drawtext=
    fontfile=${font_file}:
    text='%{pts\:hms}':
    fontsize=64:
    box=1:
    x=(w-tw)/2:y=h-(1*lh)-10,
fps=50,
setsar=1:1,
format=rgb
[out0]' -map '[out0]' -map '[out1]' '${$1%.*}-spectrogram.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
