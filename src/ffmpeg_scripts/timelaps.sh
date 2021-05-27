#!/bin/zsh
# Description:
# Concatonate any number of images into video.
#
# Args:
# <list of files in srgb png or jpg>.
#
# Out:
# <timelaps>.nut
#

rm concat_files.txt 2>/dev/null
for file in $@
do
    echo file ${file} >> concat_files.txt
done
size=3840x2160
. $(dirname "$0")/encoding.sh
cmd="${exe} -f concat -safe 0 -guess_layout_max 0 -i concat_files.txt ${enc} -filter_complex \
\"
[0:v]
scale=in_range=full:out_range=full,
format=yuv444p16le,
pad='ih*16/9:ih:(ow-iw)/2:(oh-ih)/2',
$(image_ingest_bt709 ${size}),
fps=${r},
setsar=1:1,
zscale=
    rin=full:
    r=full
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' -map_metadata -1 'timelaps.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

echo '================================================================================'
echo Your file is timelaps.nut
echo '================================================================================'

rm concat_files.txt

. $(dirname "$0")/review.sh "timelaps.nut"
