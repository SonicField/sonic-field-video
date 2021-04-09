#!/bin/zsh

# Description:
# Creates a video showing just the difference between two inputs
#
# Args:
# <video a> <video b>
#
# <*-difference>.nut
#

. $(dirname "$0")/encoding.sh
len=$($(dirname "$0")/get_length.sh "${1}")
cmd="${exe} -i '${1}' -i '${2}' -to ${len} ${enc} -filter_complex \
\"
[0:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le
[va];

[1:v]
zscale=
   rin=full:
   r=full,
format=gbrp16le
[vb];

[va][vb]
blend=
    all_mode=difference,
normalize,
zscale=
   rin=full:
   r=full
[v];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[v]' -map '[a]' '${1%.*}-difference.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
