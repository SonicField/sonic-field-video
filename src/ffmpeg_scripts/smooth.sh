#!/bin/zsh

# Description:
# Shows only the changing parts of a video.
#
# Args:
# <video in> 
#
# Out:
# <*-motion>.nut
#

fps=$($(dirname "$0")/get_fps.sh "${1}")
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex ' 
\"
[0:v]
format=rgba,
minterpolate=
    fps=$((${fps}*7)):
    mi_mode=mci:
    mc_mode=aobmc:
    me_mode=bilat:
    me=epzs:
    mb_size=16,
tmix=
    frames=7:
    weights='0.2 0.4 0.8 1 0.8 0.4 0.2',
scale=
    size=1920x1080:
    flags=lanczos,
minterpolate=
    fps=${r}:
    mi_mode=blend
[v]
\" -map '[v]' '${1%.*}-smooth.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

