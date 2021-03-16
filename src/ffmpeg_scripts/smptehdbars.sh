#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# Create a pixel bare map of rgb for chrome subsampling invstigation at fine bar size
#
# Out:
# <rgb-fine-bars>.nut
#

font_file=$(dirname "$0")/Arial-Unicode.ttf
. $(dirname "$0")/encoding.sh
cmd="${exe} -to 60 ${enc} -filter_complex \"
smptehdbars=
   r=25:
   s=1920x1080:
   sar=1:1:
   d=60,
scale=in_range=full:out_range=full
[v]

\" -map '[v]' 'smptehdbars.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
