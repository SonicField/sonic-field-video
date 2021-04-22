#!/bin/zsh
# Description:
# Create a fast to play review only version of a video called view.mov
# with time stamps.  Can be viewed in quicktime or ffplay.
# This uses the Apple hardware encoder so will only work on a Mac.
# Note that most of the time in this scripts is actually spent decoding incoming
# hvec is the 12 bit hevc pipeline is used!
#
# Do not rely on the color or brightness produced - it is 'probably OK' at best.
#
# <video in name>
#
# Out:
# view.mov
#

. $(dirname "$0")/encoding.sh
font_file=$(dirname "$0")/Arial-Unicode.ttf
len=$($(dirname "$0")/get_length.sh "${1}")
cmd="${exe} -y -i '${1}' -to ${len} ${review_enc} -vf \"
zscale=
    npl=3000:
    w=in_w/2:
    h=in_h/2:
    rin=full:
    t=bt709:
    m=bt709:
    c=left:
    p=bt709,
drawtext=
    fontfile=${font_file}:
    text='%{n} %{pts\:hms}':
    fontsize=48:
    x=(w-tw)/2:y=h-(2*lh):
    shadowcolor=black:
    shadowx=6:
    shadowy=6:
    fontcolor=yellow:
    boxcolor=black
\"  '${1%.*}-review.mov'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
