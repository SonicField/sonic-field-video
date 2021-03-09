#!/bin/zsh

# Description:
# Uses a mition sensitive blur to blur static parts of the image
#
# Args:
# <overlay video> <cut level> <decay> <sigma> <hue>
#
# Out:
# <*-msb>.nut
#

# Values which seem to work for the Brio are for 4k are
# cut=2
# dec=0.99
# sig=5 to 10
# hue=15 for daylight and 5 for nightime
# curve mid point 0.5 for bright light 0.75 for darker.
vin=$1
cut=$2
dec=$3
sig=$4
hue=$5
cmp=$6

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${vin}' ${enc} -filter_complex \
\"
[0:v]
setsar=1:1,
setpts=PTS-STARTPTS,
format=rgba,
split=3
[orig1][orig2][isharp];

[isharp]
gblur=
    sigma=4,
tblend=
    all_mode=difference,
gblur=
    sigma=8,
geq=
    lum='gt(lum(X,Y),${cut})*255':
    cb='gt(lum(X,Y),${cut})*255':
    cr='gt(lum(X,Y),${cut})*255',
lagfun=
    decay=${dec},
gblur=
    sigma=16
[sharp];

[orig2]
gblur=
    sigma=${sig},
tmix=
    frames=2
[origb];

[origb][orig1][sharp]
maskedmerge,
split=3
[first1][first2][isharp2];

[isharp2]
gblur=
    sigma=2,
tblend=
    all_mode=difference,
gblur=
    sigma=4,
geq=
    lum='gt(lum(X,Y),${cut})*255':
    cb='gt(lum(X,Y),${cut})*255':
    cr='gt(lum(X,Y),${cut})*255',
lagfun=
    decay=${dec},
gblur=
    sigma=8
[sharp2];

[first2]
gblur=
    sigma=${sig}/2,
tmix=
    frames=2,
gradfun=
    radius=16
[firstb];

[firstb][first1][sharp2]
maskedmerge,
curves=
    master='0/0.0 0.5/${cmp} 1/1',
hue=h=${hue}:
    s=0.9,
vignette
[v]

\" -map '[v]' '${1%.*}-msb.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

