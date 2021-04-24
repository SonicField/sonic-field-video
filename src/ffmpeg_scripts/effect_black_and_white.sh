#!/bin/zsh
# Description:
# Creates a sharp black and white image favouring the red channel and less the blue
# to produce a nice 'sharp moody black and white' effect. Can have temporal denoise as
# noise is wanted.
#
# Args:
# <video in name> <denoise>
#
# If denoise is set, use this as the number of frames for temporal denoise
#
# Out:
# <in-baw>.nut
#

denoise=''
[[ ($2) ]] && denoise="atadenoise=s=${2};zscale=rin=full:r=full,"

. $(dirname "$0")/encoding.sh
lut=$(get_clut clut-mono)
len=$($(dirname "$0")/get_length.sh "${1}")
width=$($(dirname "$0")/get_width.sh "${1}")
height=$($(dirname "$0")/get_height.sh "${1}")
cmd="${exe} -y -i '${1}' -i '${1}' ${enc}  -to ${len} -filter_complex \"
[0:v]
zscale=
    rin=full:
    r=full,
format=gbrp16le
[vin];

movie='${lut}',
zscale=
    rin=full:
    r=full,
format=gbrp16le
[vc];

[vin][vc]
haldclut,
zscale=
    rin=full:
    r=full,
${denoise}
tpad=
    stop=1:
    stop_mode=clone,
zscale=
    rin=full:
    r=full,
format=gbrpf32le,
split=3
[va][vb][vc];

[vc]
zscale=
    h=ih/2:
    w=iw/2:
    rin=full:
    r=full,
zscale=
    h=${height}:
    w=${width}:
    rin=full:
    r=full
[blured];

[vb][blured]
blend=
    all_mode=subtract,
zscale=
    rin=full:
    r=full
[vm];

[va][vm]
blend=
    all_expr='A+B',
zscale=
   rin=full:
   r=full
[v];

[1:a]
asetpts=PTS-STARTPTS
[a]\" -map '[v]' -map '[a]' -map_metadata -1 '${1%.*}-baw.nut'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

. $(dirname "$0")/review.sh "${1%.*}-baw.nut"
