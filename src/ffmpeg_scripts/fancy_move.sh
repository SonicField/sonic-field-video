#!/bin/zsh

# Description:
# 
# Overlay an clip onto another with the perspective filter and alpha
# 
# Args:
# <base-clip> <overlay-clip> <x0> <y0> <x1> <y1> x2> <y2> <x3> <y3>  <amax>
#
# Out:
# <*-perspective>.nut

len=$($(dirname "$0")/get_length.sh "${1}")
. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' -i '${2}' ${enc} -to $len -filter_complex \
'
color=
    c=0x00000000:
    s=1980x1080:
    r=50 
[bg];

[1:v]
format=rgba,
scale=
   size=1920x1080:
   flags=lanczos,
drawbox=
    width=iw:
    height=ih:
    thickness=1:
    color=0x00000000:
    replace=1:
    x=0:
    y=0,
perspective=
    sense=destination:
    eval=init:
    x0=${3}:
    y0=${4}:
    x1=${5}:
    y1=${6}:
    x2=${7}:
    y2=${8}:
    x3=${9}:
    y3=${10},
colorlevels=
    aomax=${11},
boxblur=
    0:0:0:0:3:1.0
[ov1];

[bg][ov1]
overlay
[ov1];

[v:0][ov1]
    overlay
[vout]

' -map '[vout]'  '${1%.*}-perspective.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
