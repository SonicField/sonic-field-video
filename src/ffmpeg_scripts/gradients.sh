#!/bin/zsh
# Description:
# Ingest video for editing
#
# Args:
# Create a pixel bare map of rgb for chrome subsampling invstigation at fine bar size
#
# Out:
# <gradients>.nut
#

font_file=$(dirname "$0")/Arial-Unicode.ttf
. $(dirname "$0")/encoding.sh
cmd="${exe} -to 60 ${enc} -filter_complex \"
nullsrc=
   s=3840x2160:
   r=25:
   d=60,
format=gbrp16le,
geq=
r='min(65535,(65535*X/3840)*gt(Y,200)*gt(Y, 200)*(lt(Y, 800) + gt(Y, 1400) + 0.5*gt(Y,1600)) + (65535*gt(Y, 1996)))':
g='min(65535,(65535*X/3840)*gt(Y,200)*gt(Y, 400)*(lt(Y, 1000)+gte(Y, 1200)*lte(Y,1400) + 0.5*gt(Y,1800)) + (65535*gt(Y, 1996)))':
b='min(65535,(65535*X/3840)*gt(Y,200)*gt(Y, 600)*(lt(Y, 1200) + gt(Y, 1400)) + (65535*gt(Y, 1996)))'
[v]

\" -map '[v]' 'gradients.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
