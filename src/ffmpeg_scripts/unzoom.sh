#!/bin/zsh

# Description:
#
# Zoom out a clip
#
# Args:
# <clip> <size - 2 = 1080> <zoom to (e.g. 1.1)> <lr offset> <tb offset>
# lr offset = position to zoom to 0 = left, 0.5 = middle
# tb offset = position to zoom to 0 = top, 0.5 = middle
# Tidy up an image for 4K
# 
# Out:
# <*-unzoom>.nut
#

size=$((960*${2}))x$((540*${2}))

. $(dirname "$0")/encoding.sh

len=$($(dirname "$0")/get_length.sh "${1}")
size=$((960*${2}))x$((540*${2}))
cx=$((960*${2}*${4}))
cy=$((540*${2}*${5}))
frames=$((${len}*${r}))
scaler=$(( (${3}-1.0)/${frames} ))
echo "Frame scaler = ${scaler}"

cmd="${exe} -y -i '${1}' ${enc} -ss 0 -to ${len} -filter_complex \
\"
[0:v]
zscale=
    rin=full:
    r=full,
format=yuv444p16le,
geq=
    lum='lum((X-${cx})/(1+${scaler}*(${frames}-N))+${cx}, (Y-${cy})/(1+${scaler}*(${frames}-N))+${cy})':
    cr='cr((X-${cx})/(1+${scaler}*(${frames}-N))+${cx}, (Y-${cy})/(1+${scaler}*(${frames}-N))+${cy})':
    cb='cb((X-${cx})/(1+${scaler}*(${frames}-N))+${cx}, (Y-${cy})/(1+${scaler}*(${frames}-N))+${cy})',
zscale=
    rin=full:
    r=full
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-unzoom.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
