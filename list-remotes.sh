#!/bin/bash
rclone listremotes |\
while IFS= read -r REMOTE
do {
echo $REMOTE
rclone about --full $REMOTE
} done
