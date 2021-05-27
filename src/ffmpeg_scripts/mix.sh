#!/bin/zsh

# Description:
#
# Mix two clips takig the audio and length from the first
#
# Args:
# <clip first> <amount> <clip second> <amount>
#
# Amount is a simple linear multiplier of the brightness of the clip.
#
# Out:
# <*-mix>.nut
#

. $(dirname "$0")/encoding.sh

len=$($(dirname "$0")/get_length.sh "${1}")
cmd="${exe} -y -i '${1}' -i '${1}' -i '${3}' ${enc} -ss 0 -to ${len} -filter_complex \
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
    all_expr='A*${2} + B*${4}',
zscale=
    rin=full:
    r=full
[v]
\" -map '[v]' -map 1:a -map_metadata -1 '${1%.*}-mix.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-mix.nut"
