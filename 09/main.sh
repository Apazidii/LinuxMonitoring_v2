#!/bin/bash

# output_file="/usr/share/nginx/html/metrics.html"
output_file="./metrics.html"

if [ $# != 0 ]
then
    echo "Ошибка: неверное количество аргументов." >&2
    exit 1
fi

function print_metric() {
    echo "# TYPE $1 gauge" >> "$output_file"
    echo "$1 $2" >> "$output_file"
}

while true; do
    myex_cpu="$(cat /proc/loadavg | awk '{print $1}')"
    myex_ram="$(free | grep Mem | awk '{print $2}')"
    myex_ram_us="$(free | grep Mem | awk '{print $3}')"
    myex_space="$(df /| grep / | awk '{print $2}')"
    myex_space_us="$(df /| grep / | awk '{print $3}')"
    

    echo -n"" > $output_file

    print_metric "myex_cpu" $myex_cpu
    print_metric "myex_ram" $myex_ram
    print_metric "myex_ram_us" $myex_ram_us
    print_metric "myex_space" $myex_space
    print_metric "myex_space_us" $myex_space_us
    
    echo "[$(date +%s)] Program working..."
    sleep 3
done
