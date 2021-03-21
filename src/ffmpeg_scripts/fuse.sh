#!/bin/zsh
# Description:
# Concatonate too videos hnutng reprocessed them to matching formats
# This re-encodes the video to ensure the connections are correct.
#
# Args:
# <list of files to concat assuming they are ingested format>
#
# Out:
# <fuse>.nut
#

rm concat_files.txt 2>/dev/null
for file in $@
do
    echo file ${file} >> concat_files.txt
done

. $(dirname "$0")/encoding.sh
cmd="${exe} -f concat -safe 0 -guess_layout_max 0 -i concat_files.txt ${review_enc} 'fused.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm concat_files.txt

