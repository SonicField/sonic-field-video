#!/bin/zsh

# Description:
# Applies a vignette effect with chromatic variation towards corners
#
# Args:
# <video in>
#
# Out:
# <*-vignette>.nut

# Chromatic values for vignette
vigr=1.90
vigg=1.85
vigb=1.80

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le,
geq=
    r='r(X,Y) * gauss((X/W-0.5)*${vigr})*gauss((Y/H-0.5)*${vigr})/gauss(0)/gauss(0)':
    g='g(X,Y) * gauss((X/W-0.5)*${vigg})*gauss((Y/H-0.5)*${vigg})/gauss(0)/gauss(0)':
    b='b(X,Y) * gauss((X/W-0.5)*${vigb})*gauss((Y/H-0.5)*${vigb})/gauss(0)/gauss(0)',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-vignette.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
