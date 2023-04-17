#!/bin/bash

# функция получает 2 агрумента 
# 1 - алфавит 
# 2 - номер папкиyz
# функция вернет название папки
function generate_DIRname(){
    local result="$1"
    local num=$2
    local last_char=${result: -1}

    for ((i=0; i<$num; i++)); do
        result="${result}$last_char"
    done
    
    result="${result}_${current_date}"
    echo $result
}

# функция получает 2 агрумента 
# 1 - алфавит 
# 2 - номер файла
# функция вернет название файла
function generate_FLname(){
    local filename=$1
    local num=$2
    local name="${filename%.*}"
    local ext="${filename##*.}"
    local last_char="${name: -1}"
    for ((i=0; i<$num; i++)); do
        name="${name}$last_char"
    done

    name="${name}_${current_date}.${ext}"
    echo $name
}


function genetane_DIR() {
    local DIR_PATH=$1
    local DIR_NAME=$2

    if [ ! -d "${DIR_PATH}/${DIR_NAME}" ]; then
        mkdir "${DIR_PATH}/${DIR_NAME}"
        echo -e "${DIR_PATH}/${DIR_NAME} ${current_date}" >> $LOG_FILE
        return 0
    else
        return 1
    fi
}

function generate_FILE() {
    local FL_PATH=$1
    local FL_NAME=$2
    local FL_SIZE=$3
    # FL_SIZE=$(( FL_SIZE * 1024 ))


    if [ ! -f "${FL_PATH}/${FL_NAME}" ]; then
        touch "${FL_PATH}/${FL_NAME}"
        fallocate -l $FL_SIZE "${FL_PATH}/${FL_NAME}"
        echo -e "${FL_PATH}/${FL_NAME} ${current_date} $FL_SIZE" >> $LOG_FILE
        return 0
    else
        return 1
    fi
}

function generate_FILES() {
    local FL_PATH=$1
    local FL_NUM=$2
    local FL_APL=$3
    local FL_SIZE=$4
    local FL_NAME

    for ((j=0; j<$FL_NUM; j++)); do
        FREE_SPACE=$(df -k / | awk '{print $4}' | tail -n 1)
        
        if [[ $FREE_SPACE -le 1048576 ]]; then
            echo "There is less than 1 GB of free space left"
            exit 1
        else

            FL_NAME=$(echo $(generate_FLname $FL_ALP $j))
            generate_FILE ${FL_PATH} ${FL_NAME} "$FL_SIZE"
            if [ $? -eq 1 ]; then 
                ((FL_NUM++))
            fi
        fi
    done
}

function run() {
    local DIR_PATH=$1
    local DIR_NUM=$2
    local DIR_ALP=$3
    local FL_NUM=$4
    local FL_ALP=$5
    local FL_SIZE=$6
    local DIR_NAME
    
    for ((i=0; i<$DIR_NUM; i++)); do
        FREE_SPACE=$(df -k / | awk '{print $4}' | tail -n 1)
        
        if [[ $FREE_SPACE -le 1048576 ]]; then
            echo "There is less than 1 GB of free space left"
            exit 1
        else
            DIR_NAME=$(echo $(generate_DIRname $DIR_ALP $i))
            genetane_DIR $DIR_PATH $DIR_NAME
            if [ $? -eq 1 ]; then 
                ((DIR_NUM++))
                continue
            fi
            generate_FILES "${DIR_PATH}/${DIR_NAME}" $FL_NUM $FL_ALP $FL_SIZE


        fi
    done
}

