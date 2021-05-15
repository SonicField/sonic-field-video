#!/bin/zsh

# Description:
# Grades a clip using luminosity value and gamma, color gamma and colour levels.
# However, the color levels only impact where the particular color channel is active in the
# CR,CB and (synthetic) CG space.  I.E a change in the R value will have no effect if the CR
# channel is negative (i.e. a shade of green) for example.
#
# This input is passed through a normalizer with a long time delay to bracket it.
#
# The result is passed through range limiting lut (reinhard) then a gamut limiter lut
# which tipically results in a soft pleasant look. For details see effect brighten.
#
# The net result is a 'nice video' which is not striking but will have a soft appearance and sort of work
# most of the time for youtube style video where one is not aiming for extreme HDR effects.
#
# Args:
# <video in> <brighten amount> <luma gamma amount> <chroma gamma amount> <green> <blue> <red>
#
# Examples:
#
# Warm summer day:   1.2 1.4 1.7 0.5 0.3 0.5
# Colourised effect: 1.2 1.4 3   0.2 0.2 0.2
#                          br   | lg  | cg   | gr  | bl  | rd
#                          -----+-----+------+-----+-----+-----
# Warm summer day          1.2  | 1.4 | 1.7  | 0.5 | 0.3 | 0.5 
# Colourised effect        1.2  | 1.4 | 3.0  | 0.2 | 0.2 | 0.2
# Gentle Old Colour        1.1  | 1.1 | 1.25 | 0.5 | 0.8 | 0.8
#
# Out:
# <*-remap-*params*>.nut
#

cg=$((1.0/${4}))

. $(dirname "$0")/encoding.sh
lut=$(get_lut bt2020-limiter)
clut=$(get_clut reinhard)
name="remap-$2-$3-$4-$5-$6-$7"
name=$( echo $name | tr . p)
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
normalize=
    independence=0:
    strength=1:
    smoothing=24,
geq=
    lum='min(1.0,pow((lum(X,Y)/65535),${3})*${2})*65535':
    cr='32767*(1+(if(lt(0,st(1, cr(X,Y)/32767-1)), ${7}, -1*${5})*pow(abs(ld(1)), ${cg})))':
    cb='32767*(1+(if(lt(0,st(1, cb(X,Y)/32767-1)), ${6}, -1*${5})*pow(abs(ld(1)), ${cg})))',
zscale=
    rin=full:
    r=full,
format=gbrpf32le
[vin];

movie='${clut}',
zscale=rin=full:r=full,
format=gbrpf32le
[vc];

[vin][vc]
haldclut=
    interp=tetrahedral,
zscale=
    rin=full:
    r=full,
lut3d=
    file='${lut}':
    interp=tetrahedral,
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
