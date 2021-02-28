# Set the global storage frame rate.
# For normal speaching video on the Brio use 25.

zmodload zsh/mathfunc
r=25
enc="-c:v libx264 -preset ultrafast -tune film -x264opts keyint=25 -qp 0 -pix_fmt yuv444p10le -sws_flags +accurate_rnd+full_chroma_int -s 3840x2160 -sar 1:1 -r ${r} -c:a pcm_s32le -ar 96K -fflags +igndts -fflags +genpts -colorspace 1 -color_primaries 1 -color_trc 1 -dst_range 1 -color_range 2"
exe=$(dirname "$0")/ffmpeg

function fps_round {
    dec=$(( int(rint((int(${1}*100%100))/2)*2) ))
    dec=$(print -f "%02d" ${dec} )
    echo $(( int(${1}) )).${dec}
}

