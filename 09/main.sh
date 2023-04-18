#!/bin/bash

output_file="/usr/share/nginx/html/metrics.html"
# output_file="./metrics.html"

if [ $# != 0 ]
then
    echo "Ошибка: неверное количество аргументов." >&2
    exit 1
fi

while true; do
  cpu_percentage=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  memory_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  memory_free=$(grep MemFree /proc/meminfo | awk '{print $2}')
  disk_usage=$(df -k / | awk '{print $4}' | tail -n 1)

  cat > "$output_file" << EOL
# TYPE system_cpu_usage gauge
system_cpu_usage $cpu_percentage
# TYPE system_memory_total gauge
system_memory_total $memory_total
# TYPE system_memory_free gauge
system_memory_free $memory_free
# TYPE system_disk_usage gauge
system_disk_usage $disk_usage
EOL
    cat $output_file
  sleep 3
done
