#! /bin/bash

curl $(node /home/kubuntu/scripts/wallpaperDownload/wallpaperDownload.js) --output "/home/kubuntu/scripts/wallpaperDownload/background.jpg"

filename=wallpaper-$(date +%Y%m%d)
cp "/home/kubuntu/scripts/wallpaperDownload/background.jpg" "/home/kubuntu/scripts/wallpaperDownload/history/$filename.jpg"

node /home/kubuntu/scripts/wallpaperDownload/wallpaperImpose.js

cp /home/kubuntu/scripts/wallpaperDownload/background.jpg /var/www/owncloud/apps/mynewtheme/core/img/background.jpg