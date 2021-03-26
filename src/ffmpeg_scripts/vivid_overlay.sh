#!/bin/zsh

# Description:
# 
# Create a vivid mix of two videos
#
# Args:
# <overlay video> <base video> 
#
# Out:
# <*-vivid>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' ${enc} -filter_complex \
\"
[0:v]
zscale,
format=gbrpf32le,
negate
[v0];

[1:v]
zscale,
format=gbrpf32le
[v1];

[v0][v1]
blend=
    all_mode=vividlight,
zscale
[v]
\" -map '[v]' '${1%.*}-vivid.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
