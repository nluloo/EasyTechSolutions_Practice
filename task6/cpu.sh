#!/bin/bash

while(true)
do grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print "CPU usage: " usage "%"}' >  /var/www/task6/index.html
sleep 1;
done;
