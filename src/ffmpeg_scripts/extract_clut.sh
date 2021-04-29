#!/bin/zsh

# Description:
# Extract a frame from a video and place along side a neutral clut
# for grading in an image editor.
#
# Args:
# <video in> <frame number>
#
# Out:
# <*-extracted>.nut
#

. $(dirname "$0")/encoding.sh
start=$((1.0 * ${2} / ${r}))
end=$(((1.0 + ${2}) / ${r}))
lut=$(get_lut smpte2084-srgb-grading)
cmd="${exe} -ss ${start} -i '${1}' -f lavfi -i haldclutsrc=16 -pix_fmt rgb48be -to ${end}  -filter_complex \
\"
[0:v]
zscale=
    rin=full:
    r=full,
format=gbrp16le,
lut3d=
    file='${lut}':
    interp=tetrahedral,
pad='iw:4096:0:0'
[right];

[1:v]
zscale=
    rin=full:
    r=full,
format=gbrp16le
[left];

[left][right]
hstack
[v]
\" -map '[v]' -frames:v 1 "${1%.*}-extracted.png
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
