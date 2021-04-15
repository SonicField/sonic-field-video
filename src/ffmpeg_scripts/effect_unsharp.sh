#!/bin/zsh

# Description:
# Uses an unsharp effect
#
# Args:
# <video in> 
#
# Out:
# <*-unsharp>.nut
#

# This is defaulted to making a nice manageable unsharp effect with a radius of about 2 pixels
# It works via scaling to produce the blured mask.
# A fully parameterised version could be written - but this 'just works' for 4K high quality input video
# without blowing out noise or edges so it a good compromise out the box. At is also quite fast by using
# the highly optimized scaling functions and works at f32 so all good there.
#
# Note: Every step reqires zscale to ensure the ranges are correct.
# Note: The script seems to hang on the last frame without an extra thrown in - check lipsink at some point.

. $(dirname "$0")/encoding.sh
len=$($(dirname "$0")/get_length.sh "${1}")
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
    h=ih/2:
    w=iw/2:
    rin=full:
    r=full,
zscale=
    h=ih*2:
    w=iw*2:
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
    all_mode=addition,
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

render_complete
