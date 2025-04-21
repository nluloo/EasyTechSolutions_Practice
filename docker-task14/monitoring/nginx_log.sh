#!/bin/bash

MAX_SIZE=$((200 * 1024))

while true
do
    filesize=$(stat -c%s /logs/double_log.log)
    if [ "$filesize" -gt "$MAX_SIZE" ]
    then
        curdate=$(date)
        true > /logs/double_log.log
        echo "[" "$curdate" "]" - "clear was successful" >> /logs/dateClear.log
    else
        tail -50 /logs/proxy_log.log > /logs/stroke_temp.log
	awk '$9 == 400' /logs/stroke_temp.log >> /logs/nginx400_log.log 
        awk '$9 == 500' /logs/stroke_temp.log >> /logs/nginx500_log.log
        cat /logs/stroke_temp.log >> /logs/double_log.log
    fi
    sleep 5
done
