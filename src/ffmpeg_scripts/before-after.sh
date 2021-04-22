#!/bin/zsh

# Description:
#
# Diagonal before/after effect.
# Audio from first clip.
#
# Args:
# <clip first> <clip second>
#
# Out:
# <*-ba>.nut
#

. $(dirname "$0")/encoding.sh

len=$($(dirname "$0")/get_length.sh "${1}")
scale=$((1. / ${len}))

cmd="${exe} -y -i '${1}' -i '${1}' -i '${2}' ${enc} -ss 0 -to ${len} -filter_complex \
\"
[0:v]
zscale=
    rin=full:
    r=full,
format=gbrpf32le
[vtop];

[2:v]
zscale=
    rin=full:
    r=full,
format=gbrpf32le
[vbottom];

[vtop][vbottom]
blend=
    all_expr='if(gt(X,W/2),B,A)',
geq=
    r='if(eq(X,W/2), 65535*lt(mod(Y, 20), 10), r(X,Y))':
    g='if(eq(X,W/2), 65535*lt(mod(Y, 20), 10), g(X,Y))':
    b='if(eq(X,W/2), 65535*lt(mod(Y, 20), 10), b(X,Y))',
zscale=
    rin=full:
    r=full
[v]
\" -map '[v]' -map 1:a -map_metadata -1 '${1%.*}-ba.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-ba.nut"
