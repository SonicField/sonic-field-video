#!/bin/zsh

# Description:
# Create a neutral clut.
#
# Out:
# neutral.png
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -f lavfi -i haldclutsrc=8 -pix_fmt rgb48be -frames:v 1 neutral.png"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
