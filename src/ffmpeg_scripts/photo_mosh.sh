#!/bin/zsh

# Description:
# Moshes a video onto itself delayed
#
# Args:
# <overlay video> <base video> <cut level> <delay frames>
#
# Out:
# <*-moshv>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
scale=in_range=full:out_range=full,
format=gbrp16le,
split=3
[over][inmosh][orig];

[inmosh]
scale=in_range=full:out_range=full,
format=rgb24,
scale=in_range=full:out_range=full,
edgedetect,
tblend=
    all_mode=difference,
scale=
    h=in_h/16:
    w=in_w/16,
scale=
    flags=neighbor:
    h=in_h*16:
    w=in_w*16,
lagfun=
    decay=0.985,
geq=
lum='gt(lum(X,Y),${2})*255':
    cb='gt(lum(X,Y),${2})*255':
    cr='gt(lum(X,Y),${2})*255',
scale=in_range=full:out_range=full
[mosh];

[over]
tmix=
    frames=25,
geq=
r='r(X,Y)*2':
g='g(X,Y)*2':
g='g(X,Y)*2'
[newover];

[orig][newover][mosh]
maskedmerge,
scale=in_range=full:out_range=full
[v]
\" -map '[v]' '${1%.*}-moshv.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

