#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name> <maskin> <background>
#
# Out:
# <*-pop1>.nut
#

. $(dirname "$0")/encoding.sh

cmd="
${exe} -i '${1}' ${enc} -vf \"shuffleframes='1 2 3 4 5 6 7 8 9 10 0'\" temp_top.nut
${exe} -i '${2}' ${enc} -vf \"shuffleframes='1 2 3 4 5 6 7 8 9 10 0'\" temp_mask.nut
"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
#. ./run.sh

cmd="${exe} -y -i temp_top.nut -i temp_mask.nut -i '${3}' ${enc} -filter_complex \"
[0:v]
format=gbrp16le,
split=2
[v1][v2];

[v1]
geq=
    r='r(X+mod(Y,10), Y)':
    g='g(X+mod(Y,10), Y)':
    b='b(X+mod(Y,10), Y)',
normalize=
    strength=0.2:
    blackpt=0x000088:
    whitept=0xFFAA00,
format=gbrp16le,
lagfun=
    decay=0.95,
tblend=
    all_mode=hardlight,
bilateral,
eq=
    contrast=2:
    brightness=-0.1,
tmix=5,
fps=5,
minterpolate=
    fps=25:
    mi_mode=mci
[vcol];

[v2]
tmix=3,
eq=
    saturation=0,
curves='0/0 0.5/0.3 1/1',
[vcol]
blend=
    difference,
normalize=
    strength=0.9,
format=gbrp16le
[vtop];

[1:v]
format=rgb24,
eq=
    contrast=2,
format=gbrp16le,
gblur
[vmask];

[2:v]
format=gbrp16le
[vbottom];

[vbottom][vtop][vmask]
maskedmerge
[v]
\" -map '[v]' 'tempv.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i tempv.nut -i '$1' -i '$1' -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-pop1.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

#shuffleframes='25 1 2 3 4 5 6 7 8 9 15 14 13 11 10 9 16 17 18 19 20 21 22 23 24 0',
