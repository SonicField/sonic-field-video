# Set the global storage frame rate.
# For normal speaching video on the Brio use 25.

zmodload zsh/mathfunc

# Frame rate
r=24

# Round correctly for computing frames.
# The magic divisor is depended on the r about TODO make this automatic
function fps_round {
    echo $((rint($1 * $r)/$r))
}

# number of threads to use
threads=16

function render_complete {
    Say "Render Complete"
}

exe=$(dirname "$0")/ffmpeg

pipe_enc="-c:v libx264 -preset ultrafast -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p10le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

review_enc="-c:v libx264 -preset ultrafast -crf 20 -c:a aac -pix_fmt yuv422p10le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

bt709_enc="-c:v libx264 -preset ultrafast -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p10le -colorspace bt709 -color_primaries bt709 -color_trc bt709 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

audio_enc="-c:a pcm_s32le -ar 96K"

enc=$pipe_enc
