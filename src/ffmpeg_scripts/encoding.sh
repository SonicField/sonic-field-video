# Set the global storage frame rate.
# For normal speaching video on the Brio use 25.

zmodload zsh/mathfunc

# Frame rate
r=25

# Round correctly for computing frames.
# The magic divisor is depended on the r about TODO make this automatic
function fps_round {
    dec=$(( int(rint((int(${1}*100%100))/2)*2) ))
    dec=$(print -f "%02d" ${dec} )
    echo $(( int(${1}) )).${dec}
}

# number of threads to use
threads=8

exe=$(dirname "$0")/ffmpeg

raw_enc="-c:v rawvideo -pix_fmt yuv444p12le -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sar 1:1 -r ${r} -c:a pcm_s32le -ar 96K -fflags +igndts -fflags +genpts -colorspace bt709 -color_primaries bt709 -color_trc linear -dst_range 1 -src_range 1 -color_range 2 -threads ${threads}"

compress_enc="-v verbose -c:v libx264 -preset ultrafast -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv444p10le -colorspace bt709 -color_primaries bt709 -color_trc linear -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sar 1:1 -fflags +igndts -fflags +genpts -r ${r} -threads ${threads} -g ${r}"

lossy_enc="-c:v libx265 -preset ultrafast -qp 1 -c:a pcm_s32le -ar 96K -pix_fmt yuv444p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -r ${r} -threads ${threads} -g ${r}"

review_enc="-c:v libx265 -preset ultrafast -qp 20 -c:a pcm_s32le -ar 96K -pix_fmt yuv444p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -r ${r} -threads ${threads} -g ${r}"

enc=$lossy_enc
