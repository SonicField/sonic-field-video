#!/bin/zsh

# Description:
# Makes something brighter or darker (exposure basically)
#
# Args:
# <video in> <brighten amount> <gama ammount> <saturation amount> <blue> <red/green>
# Fuji looks interesting at 2.1 1.2 1.0 1.0 1.0
# Fuji of waterfall: 1.0 0.75 1.3 0.4 1.0
# It will lock overbright to 100% luma - check the waveform!
# The saturation is a power effect not a direct effect; 2 takes the root so staturates a lot.
# 1.3 is vivid. 2 is rediculous.
# blue is the blue multiplier = to remove too much blue (e.g. water/sky) < 1.
# red/green is the red/green multiplier = to remove too much red/green  < 1.
#
#
# Out:
# <*-brighten>.nut
#

cg=$((1.0/${4}))

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
geq=
    lum='min(1.0,pow((lum(X,Y)/65535)*${2},${3}))*65535':
    cr='32768*(1+(if(lt(0,st(1, cr(X,Y)/32768-1)), ${6}, -1*${5})*pow(abs(ld(1)), ${cg})))':
    cb='32768*(1+(if(lt(0,st(1, cb(X,Y)/32768-1)), ${6}, -1*${5})*pow(abs(ld(1)), ${cg})))',
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-brighten.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
