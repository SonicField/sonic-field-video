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
cmd="${exe} ${enc} -filter_complex \
\"
color=
   c=black:
   size=1280x720,
format=rgb24,
scale=
    size=1920x1080,
geq=
r='if(eq(r(X,Y),0), 255, r(X,Y))':
g='if(eq(g(X,Y),0), 255, g(X,Y))':
b='if(eq(b(X,Y),0), 255, b(X,Y))'
[v]
\" -map '[v]' 'black.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

