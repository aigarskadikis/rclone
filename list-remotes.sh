#!/bin/bash

FREE_SPACE="start"

rclone listremotes |\
(
while IFS= read -r REMOTE
do 

echo $REMOTE

ABOUT="$(rclone about --full $REMOTE)"
echo "$ABOUT" | grep "Free"
FREE_SPACE="${FREE_SPACE} $(echo "$ABOUT" | grep "Free")"

#rclone lsf --recursive $REMOTE | sed "s|^|$REMOTE\/|"

echo "${FREE_SPACE}"

done 

echo "${FREE_SPACE}"
)
