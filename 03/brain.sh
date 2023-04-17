#!/bin/bash

export RM="rm -rf"


function delete_by_log() {
    local LOG_FILE
    local cut_line
    echo "Введите путь к лог-файлу"
    read LOG_FILE
    if [ -f "$LOG_FILE" ]; then
        while read -r line; do
            cut_line=$(echo "$line" | awk '{print $1}')
            if [ -f $cut_line ]; then
                $RM $cut_line
                echo "${cut_line} удалено"
            fi
        done < "$LOG_FILE"
    else
        echo "Лог-файл не найден"
    fi
}

function delete_by_date() {
    local start_datetime
    local end_datetime
    
    echo "Введите начальную дату и время (формат: ГГГГ-ММ-ДД чч:мм):"
    read start_datetime
    echo "Введите конечную дату и время (формат: ГГГГ-ММ-ДД чч:мм):"
    read end_datetime

    mapfile -t arr < <(find / -newermt "$start_datetime" ! -newermt "$end_datetime"  2>/dev/null)
    for i in "${arr[@]}"
    do
        $RM $i
        echo "${i} удалено"
    done
    
    
}

function delete_by_mask() {
    echo "Напишите маску:"
    local mask
    read mask

    local prefix=$(echo "$mask" | cut -d'_' -f1)
    
    local suffix=$(echo "$mask" | cut -d'_' -f2)
    
    local regex="^.*${prefix}+_$(echo $suffix | sed 's/\./\\./g')$"
    mapfile -t arr < <(find /home/dgalactu/Sch21/LinuxMonitoring_v2 -regex "$regex"  2>/dev/null)
    for i in "${arr[@]}"
    do
        $RM $i
        echo "${i} удалено"
    done
}







