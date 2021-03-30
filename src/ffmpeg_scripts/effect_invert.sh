#!/bin/zsh

# Description:
# Invert luma
#
# Args:
# <video in> 
#
# Out:
# <*-invert>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
geq=
lum='max(0,min(65535,(65535-lum(X,Y))))':
cr='cr(X,Y)':
cb='cb(X,Y)',
curves=
    all='0/0 0.25/0.4 0.5/0.6 1/0.9',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-invert.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh && render_complete
