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

function stage_one_complete {
    Say "Stage One Complete"
}

function render_failed {
    Say "Render Failed"
}

exe=$(dirname "$0")/ffmpeg

ten_bit_enc="-c:v libx264 -preset ultrafast -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p10le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

review_enc="-c:v hevc_videotoolbox -profile:v 0 -tag:v hvc1 -c:a aac -pix_fmt yuv420p -colorspace bt709 -color_primaries bt709 -color_trc bt709 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

bt709_enc="-c:v libx264 -preset ultrafast -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p10le -colorspace bt709 -color_primaries bt709 -color_trc bt709 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

mov_enc="-c:v libx264 -preset ultrafast -qp 15 -c:a aac -pix_fmt yuv420p10le -colorspace bt709 -color_primaries bt709 -color_trc bt709 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

twelve_bit_enc="-c:v libx265 -x265-params frame-threads=4:keyint=1:ref=1:no-open-gop=1:weightp=0:weightb=0:cutree=0:rc-lookahead=0:bframes=0:b-adapt=0 -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

twelve_bit_enc="-c:v libx265 -x265-params frame-threads=4:keyint=1:ref=1:no-open-gop=1:weightp=0:weightb=0:cutree=0:rc-lookahead=0:bframes=0:b-adapt=0 -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

audio_enc="-c:a pcm_s32le -ar 96K"

enc=$twelve_bit_enc
