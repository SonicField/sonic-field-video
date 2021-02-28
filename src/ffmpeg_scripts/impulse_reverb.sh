ffmpeg -i raw.wav -i church.wav -filter_complex '[0] [1] afir=dry=10:wet=10 [reverb]; [0] [reverb] amix=inputs=2:weights=10 1' mix.wav
