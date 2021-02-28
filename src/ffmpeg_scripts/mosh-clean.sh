#!/bin/zsh

# Description:
# Moshes one video onto another clean not bit mixed
#
# Args:
# <overlay video> <base video> <cut level> <decay>
#
# Out:
# <*-mosh-clean>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i "${2}" ${enc} -filter_complex \
\"
[0:v]
split=2
[orig][inmosh];

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
    cr='gt(lum(X,Y),${3})*255'
[mosh];

[1:v][orig][mosh]
maskedmerge
[v]
\" -map '[v]' '${1%.*}-mosh-clean.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

