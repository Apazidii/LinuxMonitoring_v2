#!/bin/bash

output_file="/usr/share/nginx/html/metrics.html"
# output_file="./metrics.html"

if [ $# != 0 ]
then
    echo "Ошибка: неверное количество аргументов." >&2
    exit 1
fi

function print_metric() {
    echo "# TYPE $1 gauge" >> $3
    echo "$1 $2" >> $3
}

while true; do
    
    myex_cpu="$(cat /proc/loadavg | awk '{print $1}')"
    myex_ram="$(free | grep Mem | awk '{print $2}')"
    myex_ram_us="$(free | grep Mem | awk '{print $3}')"
    myex_space="$(df /| grep / | awk '{print $2}')"
    myex_space_us="$(df /| grep / | awk '{print $3}')"
    
    print_metric "myex_cpu" $myex_cpu $output_file
    print_metric "myex_ram" $myex_ram $output_file
    print_metric "myex_ram_us" $myex_ram_us $output_file
    print_metric "myex_space" $myex_space $output_file
    print_metric "myex_space_us" $myex_space_us $output_file
    
    cat $output_file

    sleep 3
done
