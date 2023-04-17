

function check_input() {
    if [ "$1" -ne 1 ]; then
        echo "Ошибка: неверное количество аргументов." >&2
        exit 1
    fi

    if ! [ "$2" -eq 1 ] && ! [ "$2" -eq 2 ] && ! [ "$2" -eq 3 ] && ! [ "$2" -eq 4 ]; then
        echo "Число не равно 1, 2, 3 или 4"
    fi
}