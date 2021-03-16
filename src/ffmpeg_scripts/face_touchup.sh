#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# <video in name> <amount> amount 0.05 makes it slightly warmer for skin tone.
#
# Out:
# <*-warm>.nut
#

red_mid_point=$((0.5 + ${2}))
blue_high_point=$((1.0 - ${2}*2))

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale=rin=full:r=full,
format=gbrp16le,
curves=
    all='0/0 0.5/0.5 1/1',
curves=
    r='0/0 0.5/${red_mid_point} 1/1':
    g='0/0 0.5/0.5 1/1':
    b='0/0 0.5/0.5 1/${blue_high_point}',
geq=
r='(r(X,Y)+g(X,Y)+b(X,Y))/6 + r(X,Y)*0.5':
g='(r(X,Y)+g(X,Y)+b(X,Y))/12 + g(X,Y)*0.75':
b='(r(X,Y)+g(X,Y)+b(X,Y))/12 + b(X,Y)*0.75',
zscale=rin=full:r=full,
bilateral=
    sigmaS=0.002:
    sigmaR=0.02:
    planes=5,
atadenoise,
zscale=rin=full:r=full,
format=gbrp16le,
geq=
    r='r(X,Y)*gauss((X/W-0.5)*2)*gauss((Y/H-0.5)*2)/gauss(0)/gauss(0)':
    g='g(X,Y)*gauss((X/W-0.5)*2)*gauss((Y/H-0.5)*2)/gauss(0)/gauss(0)':
    b='b(X,Y)*gauss((X/W-0.5)*2)*gauss((Y/H-0.5)*2)/gauss(0)/gauss(0)',
zscale=rin=full:r=full
[v]
\" -map '[v]' '${1%.*}-warm.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
