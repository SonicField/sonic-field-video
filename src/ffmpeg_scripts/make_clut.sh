#!/bin/zsh

# Description:
# Create a neutral clut.
#
# Out:
# neutral.png
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -f lavfi -i haldclutsrc=8 -pix_fmt rgb48le -frames:v 1 -compression_algo raw -color_range 2 -vf 'zscale=rin=full:r=full:tin=bt709:t=smpte2084:npl=10000' neutral.tiff"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
