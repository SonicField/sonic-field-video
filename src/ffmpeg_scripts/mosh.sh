#!/bin/zsh

# Description:
# Moshes one video onto another
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
split=2
[over][inmosh];

[inmosh]
tblend=
    all_mode=difference,
scale=
    h=1080/16:
    w=1920/16,
scale=
    flags=neighbor:
    h=1080:
    w=1920,
lagfun=
    decay=${4},
geq=
lum='gt(lum(X,Y),${3})*255':
    cb='gt(lum(X,Y),${3})*255':
    cr='gt(lum(X,Y),${3})*255',
format=yuv444p
[mosh];

[1:v]
format=yuv444p,
split=2
[mixer][orig];

[over][mixer]
blend=
  c0_expr='pow(A*B,0.7)':
  c1_expr=(A+B)/2:
  c2_expr=(A+B)/2:
  c3_expr=(A+B)/2
[newover];

[orig][newover][mosh]
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

