#!/bin/bash

counterFile="/home/kubuntu/scripts/transitNew-gDrive/counter.txt"
counter=$(<$counterFile)

if [[ $counter -gt 0 ]]
then
    echo "$counter changes found. Running rclone."
    echo 0 > $counterFile
    rclone sync \
            /mnt/smbShare2/ /mnt/gDrive-Transit \
            --drive-use-trash \
            --exclude /\#recycle/ \
            -vv
else
    echo "No changes found, exiting."
fi         
