#!/bin/zsh

# Description:
# Moshes one video onto another assuming they are both in the same
# colorspace and transfer function!
#
# Args:
# <overlay video> <base video> <cut level> <decay>
#
# Out:
# <*-mosh>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i "${2}" ${enc} -filter_complex \
\"
[0:v]
split=2,
[imosh]
format=yuv444p16le,
[overlay];

[inmosh]
format=yuv444p,
tblend=
    all_mode=difference,
scale=
    h=ih/16:
    w=ih/16,
scale=
    flags=neighbor:
    h=ih*16:
    w=ih*16,
lagfun=
    decay=${4},
maskfun=
    low=${3}:
    high=${3}:
    planes=1:
    fill=white,
format=yuv444p16le
[mask];

[1:v]
format=yuv444p16le,
split=2
[mixer][base];

[overlay][mixer]
blend=
  c0_expr='pow(A*B,0.7)':
  c1_expr=(A+B)/2:
  c2_expr=(A+B)/2:
  c3_expr=(A+B)/2
[distorted];

[base][distorted][mask]
maskedmerge
[v]
\" -map '[v]' '${1%.*}-mosh.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

