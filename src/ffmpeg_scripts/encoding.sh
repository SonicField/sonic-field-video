# Set the global storage frame rate.
# For normal speaching video on the Brio use 25.

zmodload zsh/mathfunc

# Useful file locations
base_dir=$(dirname "$0")/
exe=${base_dir}/ffmpeg
player=${base_dir}/ffplay
font_file=${base_dir}/Arial-Unicode.ttf

# Frame rate
r=24

# Round correctly for computing frames.
# The magic divisor is depended on the r about TODO make this automatic
function fps_round {
    echo $((rint($1 * $r)/$r))
}

# number of threads to use - does not have much effect on the codecs...
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

# Get the file name a of a lut cube using the name (not extension).
function get_lut {
    echo ${base_dir}/luts/${1}.cube
}

# Get the file name a of a clut using the name (not extension).
function get_clut {
    echo ${base_dir}/cluts/${1}.png
}

# Scale an image from bt709 transfer and bt2020 colour space into smpte2084.
# Takes the size as a parameter. Take the brightness down below the legal limit using npl.
# Use a lut to bring this back if too much - but this is normally about correct.
function image_ingest_bt2020 {
echo "zscale=
    size=${1}:
    f=lanczos:
    rin=full:
    r=full:
    npl=5000:
    tin=709:
    min=2020_ncl:
    pin=2020:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020"
}

# Scale an image from bt709 transfer and bt709 colour space into smpte2084.
# Takes the size as a parameter. See notes about on brightness.
function image_ingest_bt709 {
echo "zscale=
    size=${1}:
    f=lanczos:
    rin=full:
    r=full:
    npl=5000:
    tin=709:
    min=709:
    pin=709:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020"
}

# Set raw colourspace.
raw_colourspace="
zscale=
    rin=full:
    r=full:
    tin=smpte2084:
    min=2020_ncl:
    pin=2020:
    t=smpte2084:
    m=2020_ncl:
    c=left:
    p=2020
"

# Useful chunks of code to avoid copy paste
# =========================================



# Codec options.
# ##############

# Note that we want any pipeline codec to be all intra because then it can be cut
# exactly.

# Very fast, 8 bit not HDR - better quality.
bt709_upload_enc="-c:v hevc_videotoolbox -profile:v 0 -tag:v hvc1 -b:v 100M -c:a aac -pix_fmt yuv420p -colorspace bt709 -color_primaries bt709 -color_trc bt709 -dst_range 1 -src_range 1 -color_range 2 -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

# 10 bit bt709 video - used to two sage ingestion (probably needs replacing).
bt709_enc="-c:v libx264 -preset ultrafast -qp 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p10le -colorspace bt709 -color_primaries bt709 -color_trc bt709 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

# 12 bit HDR codecs
# =================

# Good enough version
# -------------------
# This removes a lot of the inter pretiction stuff which makes cutting and joining more preticable and
# stable for editing. So far the level of compresion applied seems fine for 1-10 passes in a typical edit.
twelve_bit_enc="-c:v libx265 -x265-params keyint=1:ref=1:no-open-gop=1:weightp=0:weightb=0:cutree=0:rc-lookahead=0:bframes=0:b-adapt=0:strong-intra-smoothing=0 -qp 0 -preset ultrafast -c:a pcm_s32le -ar 96K -pix_fmt yuv422p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

# Experimental VP9 version
# ------------------------
# This is true lossless and works well for stack images but not so good for moving stuff.
vp9_twelve_bit_enc="-c:v libvpx-vp9 -speed 4 -row-mt 1 -frame-parallel 1 -lossless 0 -crf 0 -c:a pcm_s32le -ar 96K -pix_fmt yuv422p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

# True lossless hvec
# ------------------
# Makes HUGE files slowly but is lossless.
# It is half the speed of the lossy one and creates something link 8Gbytes per minute.
# Might be worth a try if there are significant colour shifts in post processing.
lossless_twelve_bit_enc="-c:v libx265 -x265-params lossless=1:keyint=0:ref=1 -preset ultrafast -c:a pcm_s32le -ar 96K -pix_fmt yuv422p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

# 16 Bit Uncompressed
# -------------------
raw_enc="-c:v rawvideo -c:a pcm_s32le -ar 96K -pix_fmt yuv422p12le -colorspace bt2020nc -color_primaries bt2020 -color_trc smpte2084 -dst_range 1 -src_range 1 -color_range 2 -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp -sws_dither none -sar 1:1 -fflags +igndts -fflags +genpts -vsync 1 -r ${r} -threads ${threads} -g ${r}"

# Standard audio codec
# --------------------
audio_enc="-c:a pcm_s32le -ar 96K"

# Set what video codec to use by default.
enc=${twelve_bit_enc}
