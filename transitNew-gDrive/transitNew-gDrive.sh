#!/bin/bash

counterFile="/home/kubuntu/scripts/transitNew-gDrive/counter.txt"
counter=$(<$counterFile)

# Restart service every N minutes such that if mountpoints get disconnected halfway and inotify lost track of it, this command puts it back on track
systemctl restart transit_folderMon.service

if [[ $counter -gt 0 ]]; then
    echo "$counter changes found. Running rclone."
    node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "sync" "Cloud ⇌ GDrive" "Changes found, starting sync. This sync checks and runs every 30 mins."
    echo 0 >$counterFile

    a=$SECONDS
    rclone sync \
        /mnt/smbShare2/ /mnt/gDrive-Transit \
        --drive-use-trash \
        --exclude /\#recycle/ \
        -vv
    elapsedSeconds=$((SECONDS - a))

    # Constructing the time string
    timeString=""

    if [[ $elapsedSeconds -gt 3600 ]]; then
        timeString+=$(($elapsedSeconds / 60))
        timeString+=" hours "
        elapsedSeconds=$(($elapsedSeconds % 3600))
    fi

    if [[ $elapsedSeconds -gt 60 ]]; then
        timeString+=$(($elapsedSeconds / 60))
        timeString+=" minutes "
        elapsedSeconds=$(($elapsedSeconds % 60))
    fi

    timeString+=$elapsedSeconds
    timeString+=" seconds"

    # Sending commands to webhook
    node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "sync" "Cloud ⇌ GDrive" "Sync complete. Time taken: $timeString."
else
    echo "No changes found, exiting."
fi
