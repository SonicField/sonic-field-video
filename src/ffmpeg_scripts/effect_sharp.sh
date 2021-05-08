#!/bin/zsh

# Description:
# Uses an roberts operator to sharpen.
# To reduce the radius over which the operator works - i.e. less halo around the sharpened egdes
# the image can first be scaled up before the operator then scaled back down. I am not convinced
# this offers my benefit over the unsharp filter with a small scale (i.e. range 1 < scale < 2) but
# it is a distinct effect so why not. One difference is that it seems to have more impact on strong
# edges and less on general light changes - which is in keeping with the intension. I tried sobel
# which has very interesting effects but not what I would call sharpening. Maybe I will make that
# an option in this script at some point.
#
# Args:
# <video in> <amount> <upscale> 
# 1 1 is normal.
# 2 2 is finer but more intense.
# 4 4 is a classic oversharp effect.
# The larger the upscale the finer the effect (lower radius basically).
# The larger the amount is simply multiplying the edge detecting output of the Roberts operator.
# Note that very large effect ranges can cause overflow and so go strange.
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

cmd="${exe}  -i '${1}' -i '${1}' ${enc} -to ${len} -filter_complex \
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
format=gbrp16le,
split=2
[vb][vc];

[vc]
zscale=
   rin=full:
   r=full:
   f=lanczos:
   h=ih*${3}:
   w=iw*${3},
roberts,
zscale=
   rin=full:
   r=full:
   h=${height}:
   w=${width},
geq=
   r='r(X,Y)*${2}':
   g='g(X,Y)*${2}':
   b='g(X,Y)*${2}'
[sharp];

[vb][sharp]
blend=
    all_mode=addition,
zscale=
    rin=full:
    r=full
[v]

\" -map '[v]' -map 1:a '${1%.*}-sharp.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-sharp.nut"

