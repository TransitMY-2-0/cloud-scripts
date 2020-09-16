#!/bin/bash

sleep 60
counter=0
counterFile="/home/kubuntu/scripts/transitNew-gDrive/counter.txt"
echo 0 > $counterFile
echo Counter is now $counter

inotifywait --exclude /\#recycle.*/ --event modify --event delete -mr "/mnt/smbShare2/" | while read line
do

    if [[ $counter -eq 0 ]]; then
        node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "sync" "Cloud ⇌ GDrive" "Changes found, sync imminent. You should see this message the moment you make a file change."
    fi

    counter=$(<$counterFile)
    ((counter++))
    echo $counter $line
    echo $counter > $counterFile
    counter=$(<$counterFile)
done