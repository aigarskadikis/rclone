#!/bin/bash

FREE_SPACE=""
FILES=""

# start the loop to analyze each remote (google drive)
# opening parentacy is required only because for the 
# while loop to not drop any variables (arrays in context)
rclone listremotes |\
(
while IFS= read -r REMOTE
do 

echo $REMOTE

# list used, total, free disk space and how many bytes is in trash
ABOUT="$(rclone about --full $REMOTE)"

# print bytes on screen about free disk space
echo "$ABOUT" | grep -oP "Free:\s+\K\d+"

# determine free disk space in bytes
FREE_SPACE=$(echo -e "${FREE_SPACE}\n$(echo "$ABOUT" | grep -oP "Free:\s+\K\d+") $REMOTE")

# list all files on remote and add those to array
# rclone lsf --recursive $REMOTE
FILES=$(echo -e "${FILES}\n$(rclone lsf --recursive $REMOTE | sed "s|^|$REMOTE\/|")")

done 

# remove empty lines

echo "Most free space on remotes:"
echo "${FREE_SPACE}" | sort -n

echo "All files:"
echo "${FILES}" | tee ~/gdrive.lst

)
