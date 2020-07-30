#!/bin/bash

# Unmount, just in case previous mounting has error
umount -l /mnt/gDrive-TransitArchive

# Setting variables
dateTime=$(date +%Y-%m-%d)
filename=transitMY_archive-$dateTime
echo Creating TAR archive \"$filename\"

# Write into log file
echo $(date +%Y-%m-%d\ %T) : TAR Backup Started >> ./TAR-BackupLog.log

# Doing backup
tar --exclude='*#recycle' \
    -jcvf \
    /mnt/smbShare/backupTARs/$filename.tar.gz \
    /mnt/smbShare2

echo "Backup complete, sleeping for 10 seconds."
echo $(date +%Y-%m-%d\ %T) : TAR Backup Complete >> ./TAR-BackupLog.log
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
echo $(date +%Y-%m-%d\ %T) : Google Drive folder mounted. >> ./TAR-BackupLog.log
sleep 5

echo $(date +%Y-%m-%d\ %T) : Start upload TAR to Google Drive. >> ./TAR-BackupLog.log
rsync  -vvv \
    --remove-source-files \
    /mnt/smbShare/backupTARs/* /mnt/gDrive-TransitArchive/

echo "Copy complete, sleeping for 10 seconds."
echo $(date +%Y-%m-%d\ %T) : Upload Complete. >> ./TAR-BackupLog.log
sleep 10

umount -l /mnt/gDrive-TransitArchive
echo "Drive unmounted."
echo $(date +%Y-%m-%d\ %T) : Google Drive Folder unmounted. >> ./TAR-BackupLog.log