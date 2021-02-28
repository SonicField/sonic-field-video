#!/bin/zsh

# Description:
# Fade in a clip
#
# Args:
# <video in> <fade time in seconds> <start color>
#
# Out:
# *-fade-in.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex '
[0:a]
afade=
    t=in:
    st=0:
    d=${2}
[a];
[0:v]
fade=
    t=in:
    st=0:
    c=${3}:
    d=${2}
[v]
' -map '[v]' -map '[a]' '${1%.*}-fade-in.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
