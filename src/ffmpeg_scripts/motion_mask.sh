#!/bin/zsh

# Description:
# 
# Create a simple motion mask
#
# Args:
# <overlay video> <base video> <cut level> <decay>
#
# Out:
# <*-mmask>.nut
#

cut=$((${2}*256))
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}'  ${enc} -filter_complex \
\"
[0:v]
format=gbrp16le,
tblend=
    all_mode=difference,
maskfun=
    low=${cut}:
    high=${cut}:
    sum=65535:
    planes=7,
scale=
    w=iw/16:
    h=ih/16,
scale=
    w=iw*16:
    h=ih*16:
    flags=neighbor,
lagfun=
    decay=${3},
maskfun=
    low=1024:
    high=1024:
    sum=65535:
    fill=0xFFFF,
format=gray16le
[v]
\" -map '[v]' '${1%.*}-mmask.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

