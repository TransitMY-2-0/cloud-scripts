#!/bin/bash

counterFile="/home/kubuntu/scripts/transitNew-transitOld/counter.txt"
counter=$(<$counterFile)

if [[ $counter -gt 0 ]]; then
    echo "$counter changes found. Running rclone."
    node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "copy" "Cloud ⇌ Daily snapshot" "Changes found, starting sync. This sync checks every day at 5am and runs if there are changes."
    echo 0 >$counterFile

    a=$SECONDS
    rclone sync \
        /mnt/smbShare2/ /mnt/smbShare/TransitMY \
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
    node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "copy" "Cloud ⇌ Daily snapshot" "Backup complete. Time taken: $timeString."
else
    echo "No changes found, exiting."
fi
