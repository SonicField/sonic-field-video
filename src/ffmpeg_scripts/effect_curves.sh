#!/bin/zsh

# Description:
# Add a luma curve to a clip
#
# Args:
# <video in> <all> <green> <blue> <red> <post>
#
# all: definition for all.
# green: additional green points
# blue:  additional blue points
# red:   additional red points
# post:  post processing luma curve
#
# A value of none is interpreted as no information.
#
# For example:
# '0/0 1/1' '0.5/0.6' will curve up just the greeen.
# '0/0 1/1' none none '0.5/0.4' will curve down just the red.
#
#  Settings I have used
#  ====================
#
#  Warm to blue (coutryside):
#  --------------------------
# '0/0 1/1' '0/0 1/1' '0/0 0.2/0.1 0.8/0.8 0.9/0.95 1/1' '0/0 0.2/0.3 0.8/0.8 1/1' '0/0 0.2/0.1 0.5/0.4 0.8/0.85 1/1'
#
#  Dark cold intro
#  ---------------
#  '0/0 0.5/0.1 1/0.5'
#
# Out:
# <*-curves>.nut
#
#

# Examples
# ========
#
# This brings up a dark scene without over crushing - like mobius.
# 0/0 0.2/0.10 0.5/0.65 0.8/0.85 1/1'

all=''
[[ $2 ]] && [[ $2 != none ]] && all="all='$2':"
green=''
[[ $3 ]] && [[ $3 != none ]] && green="green='$3':"
blue=''
[[ $4 ]] && [[ $4 != none ]] && blue="blue='$4':"
red=''
[[ $5 ]] && [[ $5 != none ]] && red="red='$5':"
master=''
[[ $6 ]] && [[ $6 != none ]] && master="master='$6':"


. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${1}' ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le,
curves=${all}${green}${blue}${red}${master},
zscale=
   rin=full:
   r=full
[v]
\" -map '[v]' -map 1:a '${1%.*}-curves.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-curves.nut"

