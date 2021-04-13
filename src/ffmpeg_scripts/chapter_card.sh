#!/bin/zsh

# Description:
# Make a chapter video with a synthesized voice.
# 
# Args:
# <image> 
#
# Out:
# <*->.nut

. $(dirname "$0")/encoding.sh

#
# Generate the title vioce then compute the frame length
# of that voice plus 0.5 second.
say "${2}" -v 'Serena' -o tempa.aiff
alen=$($(dirname "$0")/get_length.sh tempa.aiff)
alen=$( fps_round $((${alen}+0.5)) )

cmd="${exe} -y -i 'tempa.aiff' ${audio_enc} -to ${alen} -filter_complex '[0:a][0:a]amerge=inputs=2,apad=whole_dur=${alen}[a]' -map '[a]' tempa.wav"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

. ./run.sh

cmd="${exe} -y -i '${1}' -ss 0 -to '${alen}' ${bt709_enc} -vf \"pad='ih*16/9:ih:(ow-iw)/2:(oh-ih)/2',scale=size=3840x2160:flags=lanczos:in_range=full:out_range=full,loop=loop=-1:start=0:size=$((${r}*${alen})),fps=${r},scale=in_range=full:out_range=full\" tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

# Chromatic values for vignette
vigr=1.90
vigg=1.85
vigb=1.80

. ./run.sh
cmd="${exe} -y  -ss 0 -i tempv.nut -ss -0.5 -i tempa.wav -to '${alen}' ${enc} -filter_complex \
\"
[0:v]
fps=1,
setsar=1:1,
format=gbrp16le,
zscale=
    rin=full:
    r=full:
    npl=3000:
    tin=bt709:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020,
geq=
r='r(X,Y) * gauss((X/W-0.5)*${vigr})*gauss((Y/H-0.5)*${vigr})/gauss(0)/gauss(0)':
g='g(X,Y) * gauss((X/W-0.5)*${vigg})*gauss((Y/H-0.5)*${vigg})/gauss(0)/gauss(0)':
b='b(X,Y) * gauss((X/W-0.5)*${vigb})*gauss((Y/H-0.5)*${vigb})/gauss(0)/gauss(0)',
scale=
    in_range=full:
    out_range=full,
fps=${r}
[v]
\" -map '[v]' -map 1:a '${1%.*}-chapter.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh && render_complete
