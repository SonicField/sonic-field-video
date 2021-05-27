#!/bin/zsh

# Description:
# Blurs and an image using guassian blur. Radius is in pixels.
#
# In:
# <clip> <radius>
#
# Out:
# <*-blur-*params*>.nut
#

. $(dirname "$0")/encoding.sh
name="blur-$2"
name=$( echo $name | tr . p)
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le,
gblur=
    sigma=${2},
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
