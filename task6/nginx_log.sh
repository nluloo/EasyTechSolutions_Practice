#!/bin/bash

MAX_SIZE=$((200 * 1024))

while true
do
    filesize=$(stat -c%s /home/ubuntu/double_log.log)
    if [ "$filesize" -gt "$MAX_SIZE" ]
    then
        curdate=$(date)
        true > /home/ubuntu/double_log.log
        echo "[" "$curdate" "]" - "clear was successful" >> /home/ubuntu/dateClear.log
    else
        tail -50 /var/log/nginx/access.log > /tmp/stroke_temp.log
	awk '$9 == 400' /tmp/stroke_temp.log >> //home/ubuntu/nginx400_log.log 
        awk '$9 == 500' /tmp/stroke_temp.log >> //home/ubuntu/nginx500_log.log
        cat /tmp/stroke_temp.log >> /home/ubuntu/double_log.log
    fi
    sleep 5
done

