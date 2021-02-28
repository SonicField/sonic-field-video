#!/bin/zsh

# Description:
# Make a mono video into stereo.
#
# Args:
# <video in>
#
# Out:
# <*-stereo>.nut
#

enc="$(cat $enc)"
. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${enc} -filter_complex \
'
[0:v]
copy
[v]
;

[0:a][0:a]
amerge=
    inputs=2
[a]' -map '[v]' -map '[a]' '${1%.*}-stereo.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

