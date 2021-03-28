. $(dirname "$0")/encoding.sh

./scripts/ffmpeg \
    -y \
    -f avfoundation \
    -pix_fmt bgr0 \
    -probesize 50000000 \
    -framerate ${r} \
    -video_size 1920x1080 \
    -i "1:0" \
    -f avfoundation \
    -vcodec libx264 \
    -preset ultrafast \
    -tune zerolatency \
    -f mpegts \
    -qp 0 \
    -pix_fmt yuv444p \
    -colorspace bt709 \
    -color_primaries bt709 \
    -color_trc bt709 \
    -dst_range 1 \
    -src_range 1 \
    -color_range 2 \
    -c:a aac \
    -r ${r} \
    -sws_flags +accurate_rnd+full_chroma_int+full_chroma_inp \
    ${1}.mkv 

