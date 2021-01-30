#!/bin/bash

FREE_SPACE=""
FILES=""

# start the loop to analyze each remote (google drive)
# opening parentacy is required only because for the 
# while loop to not drop any variables (arrays in context)
rclone --config ../media.conf listremotes |\
(
while IFS= read -r REMOTE
do 

echo $REMOTE

# list used, total, free disk space and how many bytes is in trash
ABOUT="$(rclone --config ../media.conf about --full $REMOTE)"

# print bytes on screen about free disk space
echo "$ABOUT" | grep -oP "Free:\s+\K\d+"

# determine free disk space in bytes
FREE_SPACE=$(echo -e "${FREE_SPACE}\n$(echo "$ABOUT" | grep -oP "Free:\s+\K\d+") $REMOTE")

# list all files on remote and add those to array
# rclone lsf --recursive $REMOTE
FILES=$(echo -e "${FILES}\n$(rclone --config ../media.conf lsf --recursive $REMOTE | sed "s|^|$REMOTE\/|")")

done 

# remove empty lines

echo "Most free space on remotes:"
echo "${FREE_SPACE}" | sort -n

echo "${FILES}" | tee ~/google.drive.all.txt
echo "${FILES}" | grep -i "mkv\|mp4\|srt" | tee ~/Videos/Videos.txt
echo "${FILES}" | grep -i "flac" | tee ~/Music/flac.txt
echo "${FILES}" | grep -i "m4a" | tee ~/Music/m4a.txt
echo "${FILES}" | grep -i "mp3" | tee ~/Music/mp3.txt

)

# delete trash
# rclone delete remotename: --drive-trashed-only --drive-use-trash=false --verbose=2

