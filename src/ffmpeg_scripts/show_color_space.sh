#!/bin/zsh
$(dirname "$0")/ffprobe -hide_banner -loglevel warning -select_streams v -print_format json -show_frames -read_intervals "%+#1" -show_entries "frame=color_space,color_primaries,color_transfer,side_data_list,pix_fmt" -i ${1}

