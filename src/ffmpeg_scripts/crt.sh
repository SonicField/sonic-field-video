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
cmd="${exe} -i '${1}' ${enc} -filter_complex \
\"
[0:v]
format=rgb24,
geq=
r='r(X,Y) * not(eq(mod(X,3),0))':
g='g(X,Y) * not(eq(mod(X,3),1))':
b='b(X,Y) * not(eq(mod(X,3),2))',
geq=
r='min(255,r(X*0.9917+8+sin(Y/40 - T*2)*8,Y) + 0.2*g(X*0.9917+8+sin(0.25*PI + Y/40 - T*2)*8,Y))':
g='min(255,g(X*0.9917+8+sin(Y/40 - T*2)*8,Y) + 0.2*b(X*0.9917+8+sin(0.50*PI + Y/40 - T*2.2)*8,Y))':
b='min(255,b(X*0.9917+8+sin(Y/40 - T*2)*8,Y) + 0.2*r(X*0.9917+8+sin(0.75*PI + Y/40 - T*2.4)*8,Y))':
[v]
\" -map '[v]' '${1%.*}-crt.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

