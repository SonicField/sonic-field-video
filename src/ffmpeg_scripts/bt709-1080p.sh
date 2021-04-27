#!/bin/zsh
# Description:
# Make a quick bt709 version of a video for upload, sharing etc.
# Not HDR, not the best quality.
#
# <video in name> <size>
#
# Size:
# 2 = HD
# 4 = 4K
# 8 = 8K
#
# Out:
# <name-(size).mov>
#

. $(dirname "$0")/encoding.sh
font_file=$(dirname "$0")/Arial-Unicode.ttf
len=$($(dirname "$0")/get_length.sh "${1}")
size=$((960*${2}))x$((540*${2}))
cmd="${exe} -y -i '${1}' -to ${len} ${review_enc} -vf \"
zscale=
    size=${size}:
    npl=3000:
    w=in_w/2:
    h=in_h/2:
    rin=full:
    t=bt709:
    m=bt709:
    c=left:
    p=bt709
    \"  '${1%.*}-sdr-${size}.mov'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
