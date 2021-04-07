#!/bin/zsh

# Description:
# Cut a video between two points and crop to 16:9 4K centered.
#
# Args:
# <video in> <cut from seconds> <cut to seconds> 
#
# Out:
# <*-cut>.nut
#

. $(dirname "$0")/encoding.sh

# Round to the nearest frame - probably not needed but
# best to be careful.

start=$( fps_round $2 )
end=$( fps_round $3 )
length=$(printf %.f "$((${end} - ${start}))")
afade_end=$(printf %.3f "$((${end} - 0.1))")
cmd="${exe} -i '${1}' ${enc} -ss ${start} -to ${end}  -filter_complex \
'
[0:a]
afade=
    t=out:
    st=${afade_end}:
    d=0.1,
afade=
    t=in:
    st=${start}:
    d=0.1
[a];

[0:v]
crop=
    out_w=3840:
    out_h=2160:
    x=(in_w-3840)/2:
    y=(in_h-3840)/2
[v]
' -map '[v]' -map '[a]' '${1%.*}-cut.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
