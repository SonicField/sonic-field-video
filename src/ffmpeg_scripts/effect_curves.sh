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
#  Warm to blue (countryside):
#  ---------------------------
# '0/0 1/1' '0/0 1/1' '0/0 0.2/0.1 0.8/0.8 0.9/0.95 1/1' '0/0 0.2/0.3 0.8/0.8 1/1' '0/0 0.2/0.1 0.5/0.4 0.8/0.85 1/1'
#
#  Strong blue-red false colour for monochrome:
#  --------------------------------------------
#  '0/0 1/1' '0/0 1/1' '0/0 0.3/0.1 0.6/0.6 0.7/0.8 0.9/0.95 1/1' '0/0 0.2/0.4 0.7/0.7 1/1' '0/0 0.2/0.1 0.5/0.4 0.8/0.85 1/1'
#
#  Dark cold intro
#  ---------------
#  '0/0 0.5/0.1 1/0.5'
#
#  Bring down blow out monochrome highlights
#  -----------------------------------------
#  Sometimes importing 'Arcros' Fuji monochrome stills comes out too bright, this seems to get them
#  back to where they should be.
#  '0/0 0.3/0.20 0.5/0.45 0.95/0.9 1/1'
#
#  Dusk To Day
#  -----------
#
#  Post normalization:
#  '0/0 0.4/0.55 0.9/0.9 1/1'
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

