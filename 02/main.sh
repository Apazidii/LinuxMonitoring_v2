#!/bin/bash


. ./valid.sh
. ./brain.sh

export current_date=$(date +%d%m%y)
export FREE_SPACE=$(df -k / | awk '{print $4}' | tail -n 1)
export LOG_FILE="log.txt"
touch $LOG_FILE

check_input "$1" "$2" "$3"

export start_time=$(date +%s)  # сохраняем время начала выполнения скрипта в секундах с начала эпохи UNIX

mapfile -t arr < <(find / -type d -perm -o+w 2> /dev/null | grep -v -e proc -e bin -e sbin -e Permission)
export NUMBER_DIR="${#arr[@]}"
echo "Start"

function gen_path {
    local NUMBER=$RANDOM
    let "NUMBER %= NUMBER_DIR"
    echo "${arr[$NUMBER]}"

}

function pre_run {
    local DIR_ALP="$1"
    local FL_ALP="$2"
    local FL_SIZE="$3"

    local NUMBER_DIR=$RANDOM
    let "NUMBER_DIR %= 100"
    ((NUMBER_DIR++))
    local NUMBER_FL=$RANDOM
    
    let "NUMBER_FL %= 100"
    ((NUMBER_FL++))
    
    local DIR_PATH=$(echo $(gen_path))


    echo $DIR_PATH 
    run $DIR_PATH $NUMBER_DIR $DIR_ALP $NUMBER_FL $FL_ALP $FL_SIZE
}



while [[ $FREE_SPACE -gt 1048576 ]];
do
    pre_run $1 $2 $3
    export FREE_SPACE=$(df -k / | awk '{print $4}' | tail -n 1)
done
column -t $LOG_FILE > temp_file.txt && mv temp_file.txt $LOG_FILE

export end_time=$(date +%s)  # сохраняем время окончания выполнения скрипта в секундах с начала эпохи UNIX
export runtime=$((end_time-start_time))  # вычисляем время выполнения скрипта в секундах
echo "Total runtime: $runtime seconds"

