#!/bin/bash

umount -l /mnt/gDrive-Transit

myUpTime=$(echo $(uptime))
node /home/kubuntu/scripts/webhooks/simpleServerWebhook.js 0x9C27B0 "server" "SERVER" "Server Shutdown. $myUpTime"
