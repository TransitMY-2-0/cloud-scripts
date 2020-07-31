#!/bin/bash

umount -l /mnt/gDrive-Transit
node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x9C27B0 "server" "SERVER" "Server Shutdown."
