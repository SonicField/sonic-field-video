#!/bin/zsh

# Description:
# Make a chapter video with a synthesized voice.
# This one has no vignette.
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
# --rate=100 for slow slured voice.
say "${2}" --rate=100 -v 'Serena' -o tempa.aiff
alen=$($(dirname "$0")/get_length.sh tempa.aiff)
alen=$( fps_round $((${alen}+0.5)) )

cmd="${exe} -y -i 'tempa.aiff' ${audio_enc} -filter_complex '[0:a][0:a]amerge=inputs=2[a]' -map '[a]' tempa.wav"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

. ./run.sh

cmd="${exe} -y -i '${1}' -ss 0 -to '${alen}' ${bt709_enc} -vf 'scale=size=3840x2160:flags=lanczos:in_range=full:out_range=full,loop=loop=-1:start=0:size=$((${r}*${alen})),fps=${r},scale=in_range=full:out_range=full' tempv.nut"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh

. ./run.sh
cmd="${exe} -y  -ss 0 -i tempv.nut -ss -0.5 -i tempa.wav -to '${alen}' ${enc} -filter_complex \
\"
[0:v]
fps=1,
setsar=1:1,
format=gbrpf32le,
zscale=
    npl=10000:
    d=error_diffusion:
    rin=full:
    r=full:
    t=linear,
tonemap=linear:
    param=4:
    desat=0,
zscale=
    npl=10000:
    rin=full:
    tin=linear:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020:
    r=full,
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
