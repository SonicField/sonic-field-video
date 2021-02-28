#!/bin/zsh

# Description:
# Overay a green screen onto another video bottom center scales.
#
# Args:
# <video overlay> <video base> 
#
# Out:
# <*-monologue>.avi
#

len=$($(dirname "$0")/get_length.sh "${1}")
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' ${enc} -to '${len}' -filter_complex \
'
[0:v]
setpts=PTS-STARTPTS,
scale=
    1536:864,
unsharp=
    luma_msize_x=7:
    luma_msize_y=7:
    luma_amount=1.0:
    chroma_msize_x=9:
    chroma_msize_y=9:
    chroma_amount=1,
colorkey=
    0x00FF00:0.4:0.0,
despill=
    green=-1,
boxblur=
    0:0:0:0:3:1
[ckv_out];

[1:v]
setpts=PTS-STARTPTS
[v_in];

[v_in][ckv_out]
overlay=
    x=192:
    y=216,
setsar=1:1
[v];

[0:a]
asetpts=PTS-STARTPTS
[a]
' -map '[v]' -map '[a]' '${1%.*}-monologue.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
