#!/bin/zsh

# Description:
# 
# Uses a mask to merge two videos
#
# Args:
# <overlay video> <base video> <mask video>
#
# Out:
# <*-masked>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' -i '${3}' ${enc} -filter_complex \
\"
[0:v]
zscale=rin=full:r=full,
eq=
    saturation=10,
format=yuv444p16le
[v0];

[1:v]
zscale=rin=full:r=full,
format=yuv444p16le
[v1];

[2:v]
zscale=rin=full:r=full,
format=yuv444p,
geq=
    lum='gt(lum(X,Y),16)*255':
    cb='gt(lum(X,Y),16)*255':
    cr='gt(lum(X,Y),16)*255',
zscale=rin=full:r=full,
format=yuv444p16le
[v2];

[v1][v0][v2]
maskedmerge=
    planes=7,
zscale
[v]
\" -map '[v]' '${1%.*}-masked.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh && render_complete
