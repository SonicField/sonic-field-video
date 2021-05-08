#!/bin/zsh

# Description:
# Uses an unsharp effect
#
# Args:
# <video in> <amount> <scale factor> <spline36>
# 1 2 is normal.
# 2 4 would be rediculous etc.
# 2 1.5 is interesting - it is more like a traditional edge sharp and works well on 1080->4K upscale.
#
# If spline36 is set to a true value use this as the scale function
# which is less effective for low raduius but less artefact procusing for large radius.
#
# Out:
# <*-unsharp>.nut
#

# Note: Every step reqires zscale to ensure the ranges are correct.
# Note: The script seems to hang on the last frame without an extra thrown in - check lipsink at some point.

. $(dirname "$0")/encoding.sh
len=$($(dirname "$0")/get_length.sh "${1}")
width=$($(dirname "$0")/get_width.sh "${1}")
height=$($(dirname "$0")/get_height.sh "${1}")

mode='bilinear'
[[ ($4) ]] && mode='spline36'

cmd="${exe} -i '${1}' -i '${1}' ${enc} -to ${len} -filter_complex \
\"
[0:v]
zscale=
    rin=full:
    r=full,
tpad=
    stop=1:
    stop_mode=clone,
zscale=
    rin=full:
    r=full,
format=gbrpf32le,
split=3
[va][vb][vc];

[vc]
zscale=
    h=ih/${3}:
    w=iw/${3}:
    rin=full:
    r=full,
zscale=
    h=${height}:
    w=${width}:
    f=${mode}:
    rin=full:
    r=full
[blured];

[vb][blured]
blend=
    all_mode=subtract,
zscale=
    rin=full:
    r=full
[vm];

[va][vm]
blend=
    all_expr='A+B*${2}',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-unsharp.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-unsharp.nut"

