#!/bin/zsh

# Description:
# Strange curved projection
#
# Args:
# <video in> 
#
# Out:
# <*-motion>.nut
#

. $(dirname "$0")/encoding.sh
cmd="${exe} -i '${1}' -i '${2}' -i '${3}' ${enc} -to 144 -filter_complex \
\"
[0:v]
format=rgba,
lenscorrection=
    k1=0.95:
    k2=0.99,
lenscorrection=
    k1=0.95:
    k2=0.99,
lenscorrection=
    k1=0.95:
    k2=0.99,
lenscorrection=
    k1=0.95:
    k2=0.99,
colorkey=
    color=0x000000,
despill=
    green=-1:
    blue=-1:
    blue=-1,
boxblur=
    0:0:0:0:3:9.0,
rotate=sin(t/10)
[bent];

[1:v]
format=rgba,
geq=
    b='b(X,Y) * gt(b(X,Y), 8)':
    r='r(X,Y) * gt(r(X,Y), 8)':
    g='g(X,Y) * gt(r(X,Y), 8)',
rotate=sin(t/10),
curves=
   red=  '0/0 0.25/0.2 0.75/0.8 1/1':
   green='0/0 0.25/0.2 0.75/0.8 1/1':
   blue= '0/0 0.25/0.2 0.75/0.8 1/1'
[earth];

[bent][earth]
blend=
    all_mode=xor,
geq=
    b='min(b(X,Y) * (0.3 + mod(Y, 3)), 255)':
    r='min(r(X,Y) * (0.3 + mod(Y+1, 3)), 255)':
    g='min(g(X,Y) * (0.3 + mod(Y+2, 3)), 255)',
lagfun=
    decay=0.9,
format=rgba,
geq=
    r='r(X,Y)':
    g='g(X,Y)':
    b='b(X,Y)':
    a='255*gt(b(X,Y)+r(X,Y)+g(X,Y), 0)',
setpts=PTS-STARTPTS
[top];

[2:v]
loop=
    loop=-1:
    start=0:
    size=50 * 150,
hue=
    H=0.5*PI*t,
geq=
    b='b(X,Y) * abs(sin(X+T)) * abs(cos(Y+T)) ':
    r='r(X,Y) * abs(sin(X+T)) * abs(cos(Y+T)) ':
    g='g(X,Y) * abs(sin(X+T)) * abs(cos(Y+T)) ',
format=rgba
[bottom];

[bottom][top]
    overlay
[v]
\" -map '[v]' '${1%.*}-bend.nut'"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

