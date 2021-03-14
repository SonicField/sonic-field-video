#!/bin/zsh

# Description:
# Produce youtube output converted to bt709 from linear light.
# The output is in yuv42010le which seems a good compromise to send to
# youtube as I have no evidence youtube uses better then yuv420p.
#
# Compressions is x265 which gives the smallest file size for the best
# quality.  Moving crf down from 30 might make a difference but this seems
# about right in terms of internet upload speed compared to the compression
# youtube will then add.
#
# Fiddle with 'threads' for more cores, on my Mac Book Pro i9 8 is optimal;
# any more just heats up the CPU for no benefit as x265 takes most of the
# power anyhow.
#
# Args:
# <video in>
#
# Out:
# <*-youtube-bt709.mkv
#

zmodload zsh/mathfunc

$(dirname "$0")/ffmpeg -y \
    -v verbose \
    -i "$1"\
    -c:v libx265 \
    -x265-params \
       "repeat-headers=1:hdr-opt=1:colorprim=bt709:transfer=bt709:colormatrix=bt709" \
    -crf 18 \
    -preset medium \
    -c:a aac \
    -b:a 128k \
    -pix_fmt yuv420p10le \
    -r 25 \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    -colorspace bt709 \
    -color_primaries bt709 \
    -color_trc bt709 \
    -color_range 2 \
    -chroma_sample_location left \
    -threads 8 \
    -vf "
scale=in_range=full:out_range=full,
format=rgb48le,
curves=
    all='0/0 0.028/0.00075 0.5/0.22 0.75/0.54 1/1',
curves=
    all='0/0 0.5/0.45 1/1',
scale=in_range=full:out_range=full,
tonemap=clip,
scale=in_range=full:out_range=full,
zscale=
    min=unspecified:
    f=lanczos:
    tin=linear:
    range=full:
    t=bt709:
    c=left:
    p=bt709:
    m=bt709,
scale=in_range=full:out_range=full,
format=yuv420p10le
" \
${1%.*}-youtube-bt709.mkv

#geq=
#r='4*r(X,Y)*(
#(lt(0.081, st(1, 0.2126*r(X,Y)/65535 + 0.7152*g(X,Y)/65535 + 0.0722*b(X,Y)/65535))*(ld(1))/4.5) + (gte(0.081, ld(1))*pow(((ld(1))+0.099)/1.099, 1/0.45)))':
#g=4*'g(X,Y)*(
#(lt(0.081, st(1, 0.2126*r(X,Y)/65535 + 0.7152*g(X,Y)/65535 + 0.0722*b(X,Y)/65535))*(ld(1))/4.5) + (gte(0.081, ld(1))*pow(((ld(1))+0.099)/1.099, 1/0.45)))':
#b=4*'b(X,Y)*(
#(lt(0.081, st(1, 0.2126*r(X,Y)/65535 + 0.7152*g(X,Y)/65535 + 0.0722*b(X,Y)/65535))*(ld(1))/4.5) + (gte(0.081, ld(1))*pow(((ld(1))+0.099)/1.099, 1/0.45)))',
#scale=in_range=full:out_range=full,
