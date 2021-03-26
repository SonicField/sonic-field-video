#!/bin/zsh

# Description:
# Make and image into a clip.
# This is tuned to ingest sRGB png files.
# 
# Args:
# <image> <seconds-lenght>
#
# Out:
# <*->.nut

#if(C <= 0.03928)
#        lin = C/12.92;
#    else
#        lin = pow((C+0.055)/1.055, 2.4)
#    O = lin

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' -ss 0 -to '${2}' ${bt709_enc} -vf 'scale=size=3840x2160:flags=lanczos:in_range=full:out_range=full,loop=loop=-1:start=0:size=$((${r}*${2})),fps=${r},scale=in_range=full:out_range=full' tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

div=10
desat=$((1. - 3./${div}))
. ./run.sh
cmd="${exe} -y -i tempv.nut ${enc} -ss 0 -to '${2}' -filter_complex \
\"
[0:v]
fps=1,
setsar=1:1,
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
    r=full,
fps=${r}
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' '${1%.*}-image.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
