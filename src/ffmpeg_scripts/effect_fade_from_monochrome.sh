#!/bin/zsh

# Description:
# Fades to monochrome
#
# Args:
# <video in> 
#
# <*-fadem>.nut
#


. $(dirname "$0")/encoding.sh
len=$($(dirname "$0")/get_length.sh "${1}")
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
geq=
    lum='lum(X,Y)':
    cr='(cr(X,Y)-32787)*(T)/${len}+32767':
    cb='(cb(X,Y)-32787)*(T)/${len}+32767',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-fadem.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
