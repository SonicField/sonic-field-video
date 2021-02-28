#!/bin/zsh
# Description:
# Concatonate too videos hnutng reprocessed them to matching formats
#
# Args:
# <list of files to concat assuming they are ingested format>
#
# Out:
# <*-*-joined>.nut
#

rm concat_files.txt 2>/dev/null
for file in $@
do
    echo file ${file} >> concat_files.txt
    out=${out}${file%.*}-
done

$(dirname "$0")/ffmpeg -f concat -safe 0 -guess_layout_max 0 -i concat_files.txt -c:v rawvideo -c:a pcm_s32le -ar 96K  -fflags +igndts -fflags +genpts  "${out}"joined.nut
echo '================================================================================'
echo Your file is "${out}"joined.nut
echo '================================================================================'

rm concat_files.txt

