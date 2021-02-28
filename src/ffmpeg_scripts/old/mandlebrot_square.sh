#!/bin/zsh
# Description:
# Make a rotating visualizatio of mandelbrot set in a 1080 square for embedding.
#
# This does not produce 'ingested' format!
#
# Args:
# <video or audio in> 
#
# Out:
# <*-mandelbrot>.mp4
#
#
len=$($(dirname "$0")/get_length.sh "${1}")
exe="$(dirname "$0")/ffmpeg"
enc="-c:v libx264 -threads 1 -preset medium -crf 18 -s 1920x1080 -sar 1:1 -r 50 -ar 48K"
cmd="${exe} -y -i '${1}' ${enc} -ss 0 -to ${len} -filter_complex \
\"
mandelbrot=
   r=25:
   size=1080x1080,
format=rgba,
setsar=1:1,
drawbox=
    width=1080:
    height=1080:
    thickness=5:
    color=0x000000FF:
    replace=1:
    x=0:
    y=0,
drawbox=
    width=1080:
    height=1080:
    thickness=2:
    color=0x00000000:
    replace=1:
    x=0:
    y=0,
fps=50,
split=4
[squ1][squ2][squ3][squ4];

[squ1]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/150) * 763':
    y0=' 25 + sin(on/150 + PI*0.5) * 25':

    x2=' 540 + sin(on/150) * 763':
    y2='1055 - sin(on/150+PI*0.50) * 25':

    x1='540 + sin(on/150 + PI*0.5) * 763':
    y1=' 25 + sin(on/150 + PI*1.0) * 25':

    x3=' 540 + sin(on/150 + PI*0.5) * 763':
    y3='1055 - sin(on/150 + PI*1.0) * 25',
colorlevels=
    aomax=0.8
[squ_1];

[squ2]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/150 + PI*0.5) * 763':
    y0=' 25 + sin(on/150 + PI*0.5 + PI*0.5) * 25':

    x2=' 540 + sin(on/150 + PI*0.5) * 763':
    y2='1055 - sin(on/150 + PI*0.5 + PI*0.5) * 25':

    x1='540 + sin(on/150 + PI*0.5 + PI*0.5) * 763':
    y1=' 25 + sin(on/150 + PI*1.0 + PI*0.5) * 25':

    x3=' 540 + sin(on/150 + PI*0.5 + PI*0.5) * 763':
    y3='1055 - sin(on/150 + PI*1.0 + PI*0.5) * 25',
colorlevels=
    aomax=0.8
[squ_2];

[squ3]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/150 + PI*1.0) * 763':
    y0=' 25 + sin(on/150 + PI*0.5 + PI*1.0) * 25':

    x2=' 540 + sin(on/150 + PI*1.0) * 763':
    y2='1055 - sin(on/150 + PI*0.5 + PI*1.0) * 25':

    x1='540 + sin(on/150 + PI*0.5 + PI*1.0) * 763':
    y1=' 25 + sin(on/150 + PI*1.0 + PI*1.0) * 25':

    x3=' 540 + sin(on/150 + PI*0.5 + PI*1.0) * 763':
    y3='1055 - sin(on/150 + PI*1.0 + PI*1.0) * 25',
colorlevels=
    aomax=0.8
[squ_3];

[squ4]
perspective=
    sense=destination:
    eval=frame:
    x0='540 + sin(on/150 + PI*1.5) * 763':
    y0=' 25 + sin(on/150 + PI*0.5 + PI*1.5) * 25':

    x2=' 540 + sin(on/150 + PI*1.5) * 763':
    y2='1055 - sin(on/150 + PI*0.5 + PI*1.5) * 25':

    x1='540 + sin(on/150 + PI*0.5 + PI*1.5) * 763':
    y1=' 25 + sin(on/150 + PI*1.0 + PI*1.5) * 25':

    x3=' 540 + sin(on/150 + PI*0.5 + PI*1.5) * 763':
    y3='1055 - sin(on/150 + PI*1.0 + PI*1.5) * 25',
colorlevels=
    aomax=0.8
[squ_4];

[squ_1][squ_2]
overlay
[ov1];

[squ_3][squ_4]
overlay
[ov2];

[ov2][ov1]
overlay,
drawbox=
    width=1078:
    height=1078:
    thickness=2:
    color=blue:
    replace=1:
    x=1:
    y=1,
drawbox=
    width=1080:
    height=1080:
    thickness=1:
    color=0x00000000:
    replace=1:
    x=0:
    y=0
[mandel];

color=
    color=black:
    size=1920x1080,
format=rgba
[final_back];

[final_back][mandel]
overlay=
    x=360:
    y=0
[main_out];

[0:a]
showspectrum=
    s=1080x1080:
    mode=combined:
    slide=rscroll:
    saturation=2.0:
    data=magnitude:
    scale=log:
    color=rainbow:
    fscale=log,
rotate=
    bilinear=0:
    angle=PI/2,
scale=360x1080,
split
[wavsl_r][wavsr];

[wavsl_r]
hflip
[wavsl];

[main_out][wavsl]
overlay
[left_out];

[left_out][wavsr]
overlay=
    x=1440
[out];

anullsrc=
    channel_layout=stereo:
    sample_rate=96K
[a]
\" -map '[out]' -map '[a]' store/tempv.mp4"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

$(dirname "$0")/ffmpeg -i "${1}" -c:a pcm_s32le -ar 96K tempa.wav

export cmd="${exe} -i tempa.wav -i store/tempv.mp4 -c:v copy -c:a aac -b:a 256k -map 1:v -map 0:a 'store/${1%.*}-mandelbrot.mp4'"
echo
echo '================================================================================'
echo Will Run ${cmd}
echo '================================================================================'
echo
echo $cmd > run.sh
. ./run.sh

rm store/tempv.mp4
rm tempa.wav
