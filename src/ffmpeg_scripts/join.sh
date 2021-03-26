#!/bin/zsh
# Description:
# Concatonate too videos hnutng reprocessed them to matching formats
#
# Args:
# <list of files to concat assuming they are ingested format>
#
# Out:
# <joined>.nut
#

rm concat_files.txt 2>/dev/null
for file in $@
do
    echo file ${file} >> concat_files.txt
done

. $(dirname "$0")/encoding.sh
cmd="${exe} -f concat -safe 0 -guess_layout_max 0 -i concat_files.txt -c:v copy -c:a copy -fflags +igndts -fflags +genpts 'joined.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

echo '================================================================================'
echo Your file is joined.nut
echo '================================================================================'

rm concat_files.txt

render_complete
