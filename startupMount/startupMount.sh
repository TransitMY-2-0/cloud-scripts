#!/bin/bash

umount -l /mnt/gDrive-Transit

rclone mount gDrive:TransitMY /mnt/gDrive-Transit \
        --config=/root/.config/rclone/rclone.conf \
        --allow-other \
        --no-modtime \
        --drive-use-trash \
        -vvv \
        --umask 0777 
