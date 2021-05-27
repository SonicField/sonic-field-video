#!/bin/zsh

# Description:
# Uses an localized contrast enhancement effect similar to large radius 'clarity'.
# Not a classic unsharp - use unsharp for that. This is tuned for larger radius local
# contrast work by bluring a down scaled version of the video for performance and using
# a pre-curve to condition the image so the added contrast does not cause peek white to exceed
# 100% an wrap around (the samme effect probably could happen with peak black but I have not
# yet seen it).
#
# Args:
# <video in> <pre-curve> <original> <difference> <size>
# '0/0 1/1' 0.75 1.5 16 is vibrant though dark
# '0/0 1/1' 0.75 1   64 really pops
# '0/0 0.1/0.2 1/0.75' 0.75 2 64 strange crushed but bright effect
# '0/0 0.1/0.2 1/0.75' 0.8 2.5 128 landscape photographer look ;-)
# '0/0 0.1/0.15 1/0.85' 0.8 1.5 128 less extreme
#
# Out:
# <*-halo-*params*>.nut
#

# Note: Every step reqires zscale to ensure the ranges are correct.
# Note: The script seems to hang on the last frame without an extra thrown in - check lipsink at some point.

. $(dirname "$0")/encoding.sh
len=$($(dirname "$0")/get_length.sh "${1}")
width=$($(dirname "$0")/get_width.sh "${1}")
height=$($(dirname "$0")/get_height.sh "${1}")
name="halo-$2-$3-$4-$5"
name=$( echo $name | tr . p)
name=$( echo $name | tr / =)
name=$( echo $name | tr ' ' _)
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
format=gbrp16le,
curves=
    all='${2}',
zscale=
    rin=full:
    r=full,
format=gbrpf32le,
split=3
[va][vb][vc];

[vc]
zscale=
    h=ih/4:
    w=iw/4:
    f=spline36:
    rin=full:
    r=full,
gblur=
    sigma=${5},
zscale=
    h=${height}:
    w=${width}:
    f=spline36:
    rin=full:
    r=full,
format=gbrpf32le
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
    all_expr='A*${3}+B*${4}',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-${name}.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-${name}.nut"

