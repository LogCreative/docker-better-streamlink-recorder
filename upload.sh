#!/bin/bash
MONITORDIR="/etc/streamlink/scratch/$MODE/$CHANNEL/download"
ENCODE_DIR="/etc/streamlink/scratch/$MODE/$CHANNEL/encode"
set +H
inotifywait -m -r --format '%w%f' --include ".*ts" -e close_write "$MONITORDIR" | while read NEWFILE
do
        if [[ $NEWFILE = *.fragmented.mp4* ]]; then
                echo 'Skipping Fragmented File'
        else
                echo "$NEWFILE created"
                STREAMTITLE="$(basename "$NEWFILE" | sed -E 's/^[^-]+ - s[0-9]+e[0-9]+ - //; s/ - [0-9]+\.ts$//; s/</＜/g; s/>/＞/g')"
                FILENAME="$(basename "$NEWFILE")"
                echo "Stream title is: $STREAMTITLE"
                UPLOADDATE="$(date +%m/%d/%Y)"
                UPLOADTITLE="$UPLOADDATE - $STREAMTITLE"
                echo "Upload Title is: $UPLOADTITLE"
                /etc/youtubeuploader -title "$UPLOADTITLE" -privacy "public" -filename "$NEWFILE" -description "Uploaded Automatically by $UPLOAD_BOT_NAME"
                sleep 2
                echo "Finished YT Upload"
                mv "$NEWFILE" "$ENCODE_DIR/$FILENAME"
                echo moved "$NEWFILE" to "$MONITORDIR/$FILENAME"
        fi
done
