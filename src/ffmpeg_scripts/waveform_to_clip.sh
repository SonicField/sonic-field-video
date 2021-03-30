#!/bin/zsh

# Description:
# Draw the waveform of a video
#
# Args:
# <video in name>
#
# Out:
# <in name>-waveform.nut
#

. $(dirname "$0")/encoding.sh

len=$($(dirname "$0")/get_length.sh "${1}")
font_file=$(dirname "$0")/Arial-Unicode.ttf
cmd="${exe} -y -i '${1}' -i '${1}' -to ${len} ${bt709_enc} -filter_complex \"
waveform=
    c=7:
    m=column:
    e=peak:
    f=color:
    d=1:
    g=orange,
scale=
    size=3840x2160,
setsar=1:1,
drawtext=
    fontfile=${font_file}:
    text='%{n} %{pts\:hms}':
    fontsize=32:
    x=(w-tw)/2:y=h-(2*lh):
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black
\" tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

. ./run.sh && stage_one_complete

cmd="${exe} -y -i tempv.nut ${enc} -to ${len} -filter_complex \
\"
[0:v]
format=gbrpf32le,
zscale=
    npl=10000:
    d=error_diffusion:
    rin=full:
    r=full:
    t=linear,
tonemap=linear:
    param=4:
    desat=0,
zscale=
    npl=10000:
    rin=full:
    tin=linear:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
    r=full
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' '${1%.*}-waveform.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

. ./run.sh && render_complete || render_failed
