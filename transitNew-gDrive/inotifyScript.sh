#!/bin/bash

sleep 60
counter=0
counterFile="/home/kubuntu/scripts/transitNew-gDrive/counter.txt"
echo 0 > $counterFile
echo Counter is now $counter

inotifywait --exclude /\#recycle.*/ --event modify --event delete -mr "/mnt/smbShare2/" | while read line
do
    counter=$(<$counterFile)
    ((counter++))
    echo $counter $line
    echo $counter > $counterFile
    counter=$(<$counterFile)
done