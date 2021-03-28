#!/bin/zsh
# Description:
# Use scaling to perform a very slight anti-alias effect.
# It is very close to a blur but works nicely to not make the image look
# blurred.
#
# Args:
# <video in name>
#
# Out:
# <in name>-finalized.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}' ${enc} -filter_complex \"
[0:v]
zscale=
    rin=full:
    r=full,
format=yuv444p16le,
zscale=
    rin=full:
    r=full:
    f=lanczos:
    h=ih*2:
    w=iw*2,
split=2
[vi1][vi2];

[vi1]
noise=
    all_seed=$(jot -r 1 1 1000000):
    c0s=10:
    c1s=5:
    c2s=5:
    allf=p
[vn1];

[vi2]
noise=
    all_seed=$(jot -r 1 1 1000000):
    c0s=10:
    c1s=5:
    c2s=5:
    allf=p
[vn2];

[vn1][vn2]
blend=
    all_expr='A*lt(mod(T,2), 1) + B*gte(mod(T,2), 1)',
zscale=
    f=lanczos:
    rin=full:
    r=full:
    h=ih/2:
    w=iw/2
[v]
\" -map '[v]' -map_metadata -1 'tempv.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

cmd="${exe} -i tempv.nut -i '$1' -c:v copy -c:a copy -map 0:v -map 1:a '${1%.*}-finalized.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete

