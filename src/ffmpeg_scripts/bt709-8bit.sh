#!/bin/zsh

# Description:
# Produce youtube output
#
# Args:
# <video in>
#
# Out:
# <*-sdr>.mov
#


zmodload zsh/mathfunc

# Get r!
. $(dirname "$0")/encoding.sh
cmd="${exe} -y -i "$1" ${bt709_upload_enc} -vf '
format=gbrp16le,
zscale=
    r=full:
    npl=3000:
    p=bt709:
    m=bt709:
    t=bt709:
    rin=full
' ${1%.*}-sdr.mov"

echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

render_complete
