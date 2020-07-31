#!/bin/bash

# Definition of timeString function
function toTimeString() {
    timeString=""

    if [[ $1 -gt 3600 ]]; then
        timeString+=$(($1 / 60))
        timeString+=" hours "
        elapsedSeconds=$(($1 % 3600))
    fi

    if [[ $1 -gt 60 ]]; then
        timeString+=$(($1 / 60))
        timeString+=" minutes "
        elapsedSeconds=$(($1 % 60))
    fi

    timeString+=$elapsedSeconds
    timeString+=" seconds"
}

# Unmount, just in case previous mounting has error
umount -l /mnt/gDrive-TransitArchive

# Setting variables
a=$SECONDS
dateTime=$(date +%Y-%m-%d)
filename=transitMY_archive-$dateTime
echo Creating TAR archive \"$filename\"

# Write into log file
echo $(date +%Y-%m-%d\ %T) : TAR Backup Started >>./TAR-BackupLog.log

node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "archive" "Cloud ⇌ Weekly TAR Snapshot" "TAR Snapshot action started. This archive action runs every Monday at 3am."

# Doing backup
tar --exclude='*#recycle' \
    -jcvf \
    /mnt/smbShare/backupTARs/$filename.tar.gz \
    /mnt/smbShare2

# Calculating file size and generating human readable string
fileSize=$(stat --printf="%s" /mnt/smbShare/backupTARs/$filename.tar.gz)
fileSize=`echo "${fileSize} / (1024 * 1024 * 1024)" | bc -l`
fileSize=${fileSize:0:6}
fileSize+=" GB"

# Sending commands to webhook
elapsedSeconds=$((SECONDS - a))
toTimeString $elapsedSeconds
node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "archive" "Cloud ⇌ Weekly TAR Snapshot" "TAR Snapshot of size $fileSize complete. Time taken: $timeString."

echo "Backup complete, sleeping for 10 seconds."
echo $(date +%Y-%m-%d\ %T) : TAR Backup Complete >>./TAR-BackupLog.log
sleep 10

# Mounting folder for backup
rclone mount gDrive:TransitMY_Archive /mnt/gDrive-TransitArchive \
    --config=/root/.config/rclone/rclone.conf \
    --allow-other \
    --no-modtime \
    --drive-use-trash \
    -vvv \
    --daemon \
    --umask 0640 \
    --allow-non-empty

echo "Mount complete. Sleeping for 5 seconds."
echo $(date +%Y-%m-%d\ %T) : Google Drive folder mounted. >>./TAR-BackupLog.log
sleep 5

a=$SECONDS
node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "archive" "Cloud ⇌ Weekly TAR Snapshot" "Starting upload to Google Drive..."
echo $(date +%Y-%m-%d\ %T) : Start upload TAR to Google Drive. >>./TAR-BackupLog.log

rsync -vvv \
    --remove-source-files \
    /mnt/smbShare/backupTARs/* /mnt/gDrive-TransitArchive/

# Sending commands to webhook
elapsedSeconds=$((SECONDS - a))
toTimeString $elapsedSeconds
node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x009688 "archive" "Cloud ⇌ Weekly TAR Snapshot" "Upload complete. Time taken: $timeString."

echo "Copy complete, sleeping for 10 seconds."
echo $(date +%Y-%m-%d\ %T) : Upload Complete. >>./TAR-BackupLog.log
sleep 10

umount -l /mnt/gDrive-TransitArchive
echo "Drive unmounted."
echo $(date +%Y-%m-%d\ %T) : Google Drive Folder unmounted. >>./TAR-BackupLog.log
