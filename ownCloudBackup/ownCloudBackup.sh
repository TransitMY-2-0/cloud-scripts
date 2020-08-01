password=$(<"/home/kubuntu/scripts/ownCloudBackup/db-Credentials.txt")

dateTime=$(date +%Y-%m-%d_%H:%M:%S)

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

    timeString+=$1
    timeString+=" seconds"
}

# Backup owncloud database
a=$SECONDS
mysqldump \
    --single-transaction \
    -h localhost \
    -u backupUser \
    -p$password \
    owncloud_db \
    > /mnt/smbShare/ownCloudBackupFiles/owncloudDB-backup_$dateTime.ocbak

tar --exclude='*#recycle' \
    -jcvf \
    /mnt/smbShare/ownCloudBackupFiles/owncloudInstallation-backup_$dateTime.tar.gz \
    /var/www/owncloud/config \
    /var/www/owncloud/data \
    /var/www/owncloud/apps/mynewtheme

elapsedSeconds=$((SECONDS - a))
toTimeString $elapsedSeconds


node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x9C27B0 "server" "Owncloud Backup" "Database & Server Backup complete. Time taken: $timeString."