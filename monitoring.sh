#!/bin/bash

LOGFILE="system_monitor.log"
CPU_THRESHOLD=80

echo "Starting system monitoring..."
echo "Logs will be written to $LOGFILE"

while true
do
    DATE=$(date "+%Y-%m-%d %H:%M:%S")

    CPU=$(top -bn1 | grep "Cpu" | awk '{print 100 - $8}')
    MEM=$(free | grep Mem | awk '{print ($3/$2) * 100}')
    DISK=$(df -h / | awk 'NR==2 {print $5}')

    echo "$DATE | CPU: ${CPU}% | MEM: ${MEM}% | DISK: ${DISK}" | tee -a $LOGFILE

    CPU_INT=${CPU%.*}

    if [ "$CPU_INT" -gt "$CPU_THRESHOLD" ]; then
        echo "⚠ WARNING: CPU usage above $CPU_THRESHOLD%" | tee -a $LOGFILE
    fi

    sleep 10
done
