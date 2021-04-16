#!/bin/zsh

# Description:
#
# Cross fade two clips takig the audio and length from the first
#
# Args:
# <clip first> <clip second>
#
# Out:
# <*-xfade>.nut
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
    all_expr='(A*(${len}-T) + B*T)*${scale}',
zscale=
    rin=full:
    r=full
[v]
\" -map '[v]' -map 1:a -map_metadata -1 '${1%.*}-xfade.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
