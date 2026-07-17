#!/bin/bash
if [ ! -f "urls_bilibili.txt" ]; then
    echo "Error: urls_bilibili.txt not found."
    exit 1
fi
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is required but not installed."
    exit 1
fi

yt-dlp -x --audio-format mp3 \
       --audio-quality 0 \
       --add-header "Referer:https://www.bilibili.com" \
       --cookies-from-browser chrome \
       --download-archive downloaded_history.txt \
       --embed-thumbnail \
       --embed-metadata \
       --write-subs \
       --write-auto-subs \
       --sub-format "srt/vtt" \
       -o "%(title)s/%(title)s.%(ext)s" \
       -a urls_bilibili.txt
