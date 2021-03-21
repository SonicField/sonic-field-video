#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name> <warm> <brightness> <audio in>
# warm 0.05 makes it slightly warmer for skin tone. i
# rightness be careful 1.1 seems to be about right for daylight,
# note that the brightness is take down by the initial curve a bit for anything <100%
# so this helps compensate for that based on what the actual peak brightness is.
#
# Out:
# <*-ftu>.nut
#

. $(dirname "$0")/encoding.sh

# Touch up colour points.
red_mid_point=$((0.5 + ${2}))
blue_high_point=$((1.0 - ${2}*2))

# Chromatic values for vignette
vigr=1.90
vigg=1.85
vigb=1.80

# Note that biateral and curves will work at gbrp16le so we go the
# calculations in this space which is higher then the intermediate so
# very little error should be introduced.

cmd="${exe} -y -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale=rin=full:r=full,
format=gbrp16le,
zscale=
    d=error_diffusion:
    f=bilinear:
    size=3840x2160:
    rin=full:
    r=full ,
curves=
    all='0/0 0.5/0.4 1/1.0',
curves=
    r='0/0 0.5/${red_mid_point} 1/1':
    g='0/0 0.5/0.5 1/1':
    b='0/0 0.5/0.5 1/${blue_high_point}',
geq=
r='((r(X,Y)+g(X,Y)+b(X,Y))/6  + r(X,Y)*0.50) * gauss((X/W-0.5)*${vigr})*gauss((Y/H-0.5)*${vigr})/gauss(0)/gauss(0) * ${3}':
g='((r(X,Y)+g(X,Y)+b(X,Y))/12 + g(X,Y)*0.75) * gauss((X/W-0.5)*${vigg})*gauss((Y/H-0.5)*${vigg})/gauss(0)/gauss(0) * ${3}':
b='((r(X,Y)+g(X,Y)+b(X,Y))/12 + b(X,Y)*0.75) * gauss((X/W-0.5)*${vigb})*gauss((Y/H-0.5)*${vigb})/gauss(0)/gauss(0) * ${3}'
[v]
\" -map '[v]' 'tempv.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i tempv.nut -i '$1' -i '$4' -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-ftu.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

