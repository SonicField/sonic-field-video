#!/bin/zsh
# Description:
# Turns a set of photo clips into a single video with blending
#
# Args:
# <list of files to concat assuming they are ingested format>
#
# Out:
# photo-joined.nut
#

rm concat_files.txt 2>/dev/null
for file in $@
do
    echo file ${file} >> concat_files.txt
    out=${out}${file%.*}-
done

. $(dirname "$0")/encoding.sh
cmd="${exe} -f concat -safe 0 -guess_layout_max 0 -i concat_files.txt -c:v copy -c:a copy -f nut - | \
${exe} -y -i - ${enc} -filter_complex \
\"
[0:v]
format=yuv444p12le,
tmix=
    frames=${r}
[v]
\" -map '[v]' '${1%.*}-photo-joined.nut'
"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm concat_files.txt

