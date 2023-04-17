#!/bin/bash

if [ $# != 0 ]
then
    echo "Invalid number of arguments (should be 0)"
else
    echo "Введите путь к лог-файлу"
    local LOG_FILE
    read LOG_FILE
    goaccess "$LOG_FILE" --log-format=COMBINED -o report.html
fi