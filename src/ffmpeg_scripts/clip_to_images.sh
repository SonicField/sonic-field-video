#!/bin/zsh

# Description:
# Make clip into a set of png files
# 
# Args:
# <clip> <start> <end>
#
# Out:
# <*-*>.png


. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i '${1}'  -vf \"
select='between(t,${2},${3})',
format=gbrpf32le,
zscale=
    rin=full:
    r=full:
    t=linear,
tonemap=linear:
    param=0.25:
    desat=0,
zscale=
    rin=full:
    r=full:
    npl=10000:
    t=bt709:
    m=bt709:
    p=bt709
\" -vsync 0 '${1%.*}-%d.png'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

. ./run.sh && render_complete
