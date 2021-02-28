#!/bin/zsh

# Description:
# Fade in a clip
#
# Args:
# <video in> <fade time in seconds> <start colour> <end colour>
#
# Out:
# *-fade-in-out.nut
#

len=$($(dirname "$0")/get_length.sh "${1}")
. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' ${enc} -filter_complex '
[0:a]
afade=
    t=in:
    st=0:
    d=${2},
afade=
    t=out:
    st=$((${len}-${2})):
    d=${2}
[a];
[0:v]
fade=
    t=in:
    st=0:
    c=${3}:
    d=${2},
fade=
    t=out:
    st=$((${len}-${2})):
    c=${4}:
    d=${2}
[v]
' -map '[v]' -map '[a]' '${1%.*}-fade-in-out.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh
