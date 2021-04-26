#!/bin/zsh

# Description:
# Grades a clip using luminosity value and gamma, color gamma and colour levels.
# However, the color levels only impact where the particular color channel is active in the
# CR,CB and (synthetic) CG space.  I.E a change in the R value will have no effect if the CR
# channel is negative (i.e. a shade of green) for example.
#
# The result is passed through a gamut limiter lut to stop excessive excursion of the the color channels. 
#
# Args:
# <video in> <brighten amount> <luma gamma amount> <chroma gamma amount> <green> <blue> <red>
#
# Examples
# ========
#                          br   | lg  | cg  | gr  | bl  | rd
#                          -----+-----+-----+-----+-----+-----
# Direct flog countryside  1.02 | 1.2 | 1.1 | 1.1 | 0.8 | 1.1     Takes out down the sky a bit - looks nice after soften
# Control over saturated   1.0  | 1.0 | 0.9 | 1   | 1   | 1       If the near highlights are very saturated this helps
# Final 'flowers' setting  1.1  | 2   | 1   | 1.2 | 1   | 0.7     Bending luma gama viaully controlled over saturation.
# Me talking!              1.1  | 1.2 | 1   | 1   | 1   | 0.9     Bit more contrast if the input is bright, less red.
#
# Parameters In Detail:
# =====================
#
# brighten amount
# ---------------
# Linear multplier of luma after applying gamma curve.
# This should used to get peak to the legal limit.
#
# luma gmama amount
# -----------------
# Raise the scaled luma to this power.
# This is a simple power gamma.
# > 1 more constrast looking, crushed dark.
# < 1 brighter, crushed highlights.
#
# chroma gamma amount
# -------------------
# Inverse of power on chroma.  The higher the number the more saturated low saturation
# areas will look.  As colors approach pure white the effect deminishes. Gama is 1/this
# which makes it visually similar to the gama for luma; i.e. larger number = more staturates.
#
# Green
# -----
# Scale the green component of color. Only impacts where a color is green positive.
#
# Blue
# ----
# Scale the blue component of color. Only impacts where a color is blue positive.
#
# Red
# ---
# Scale the red component of color. Only impacts where a color is red positive.
#
# Notes:
# ======
#
# It will lock overbright to 100% luma - check the waveform!
# The saturation is a power effect not a direct effect; 2 takes the root so staturates a lot.
# 1.3 is vivid. 2 is rediculous.
# blue is the blue multiplier = to remove too much blue (e.g. water/sky) < 1.
# red/green is the red/green multiplier = to remove too much red/green  < 1.
#
# Out:
# <*-brighten-*params*>.nut
#

cg=$((1.0/${4}))

. $(dirname "$0")/encoding.sh
lut=$(get_lut bt2020-limiter)
name="brighten-$2-$3-$4-$5-$6-$7"
name=$( echo $name | tr . p)
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=yuv444p16le,
geq=
    lum='min(1.0,pow((lum(X,Y)/65535),${3})*${2})*65535':
    cr='32767*(1+(if(lt(0,st(1, cr(X,Y)/32767-1)), ${7}, -1*${5})*pow(abs(ld(1)), ${cg})))':
    cb='32767*(1+(if(lt(0,st(1, cb(X,Y)/32767-1)), ${6}, -1*${5})*pow(abs(ld(1)), ${cg})))',
zscale=
    rin=full:
    r=full,
format=gbrpf32le,
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
