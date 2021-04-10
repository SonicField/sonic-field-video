#!/bin/zsh
# Description:
# Ingest an flog video
#
# Args:
# <video in name> <bright multiplyer> <saturation multiplier>
#
# multipliers at 0.9 makes video look more realistic (bring verything into the legal range).
#
# Out:
# <in>.nut
#

# This scripts implements the Fuji flog transfer function in linear light.
# From the flog data sheet:
#
# F-Log conversion formula
# =======================
# a = 0.555556,
# b = 0.009468,
# c = 0.344676,
# d = 0.790453,
# e = 8.735631,
# f = 0.092864,
# cut1 = 0.00089,
# cut2 = 0.100537775223865,
#
# Scene Linear Reflection to F-Log
# --------------------------------
#       out =  c * Log10(a * in + b) + d    ( in >= cut1 )
#       out =  e * in + f                   ( in < cut1 )
#             in = reflection
#             0.0 <= out <= 1.0
#
# F-Log to Scene Linear Reflection
# --------------------------------
#       out = (10^((in - d) / c)) / a - b / a   ( in >= cut2)
#       out = (in - f) / e                      ( in < cut2)
#             0.0 <= in <= 1.0
#             out = reflection
#
# If we plug 1 into the F-log value we get out 7.28132488049 so we can
# use the value 0->7.28132488049 is the resulting linear range and convert
# that to 0->65535 in linear light.

debright=${2}
desaturate=${3}

cut2=0.100537775223865
a=0.555556
b=0.009468
c=0.344676
d=0.790453
e=8.735631
f=0.092864
ba=$((${b} / ${a}))
# 7.2... is the maximum linear reflection so we scale by that.
scale=$((65535/7.28132488049))

. $(dirname "$0")/encoding.sh
voff=$( fps_round $2 )
cmd="${exe} -y -i '${1}' -i '${1}' ${twelve_bit_enc} -filter_complex \"
[0:v]
zscale=rin=full:r=full,
format=gbrp16le,
zscale=
    tin=linear:
    min=2020_ncl:
    pin=2020:
    rin=full:
    r=full:
    t=linear:
    m=2020_ncl:
    c=left,
geq=
r='if(lt(st(1, r(X,Y)/(65535)),${cut2}), (ld(1)-${f})/${e}, pow(10, ((ld(1)-${d})/${c}))/${a} - ${ba})*${scale}':
g='if(lt(st(1, g(X,Y)/(65535)),${cut2}), (ld(1)-${f})/${e}, pow(10, ((ld(1)-${d})/${c}))/${a} - ${ba})*${scale}':
b='if(lt(st(1, b(X,Y)/(65535)),${cut2}), (ld(1)-${f})/${e}, pow(10, ((ld(1)-${d})/${c}))/${a} - ${ba})*${scale}',
format=gbrpf32le,
zscale=
    tin=linear:
    min=2020_ncl:
    pin=2020:
    rin=full:
    r=full:
    npl=10000:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020,
format=yuv422p16le,
geq=
lum='lum(X,Y)*${debright}':
cr='${desaturate}*(cr(X,Y)-32767)+32767':
cb='${desaturate}*(cb(X,Y)-32767)+32767'
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-exp.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0") ./review.sh '${1%.*}.nut'
