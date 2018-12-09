#!/bin/bash

# Получаем аргументы...
if [ "$2" = "" ] ; then
    if [ "$1" = "--help" ] ; then
        echo "Usage: $0 [PATH [USERNAME:GROUP]]"
        echo ""
        echo "PATH - путь к каталогу, куда скрипт будет сохранять картинки."
        echo "       Если не указан, программа будет сохранять в текущий каталог."
        echo ""
        echo "USERNAME - имя пользователя для chown."
        echo ""
        echo "GROUP - имя группы для chown."
        exit
    elif [ "$1" = "" ] ; then
        NR_PATH="."
        USER_NAME=""
    else
        NR_PATH="$1"
        USER_NAME=""
    fi
else
    NR_PATH="$1"
    USER_NAME="$2"
fi

# Создаём "корень" и устанавливаем права...
if [ ! -d "$NR_PATH" ] ; then
    mkdir --parents "$NR_PATH"
    if [ "$USER_NAME" != "" ] ; then
        chown $USER_NAME "$NR_PATH"
    fi
fi

# Теперь определяем подкаталог...
NR_PATH="$NR_PATH/$(date '+%Y-%m')"

# Создаём подкаталог и устанавливаем права...
if [ ! -d "$NR_PATH" ] ; then
    mkdir --parents "$NR_PATH"
    if [ "$USER_NAME" != "" ] ; then
        chown $USER_NAME "$NR_PATH"
    fi
fi

# Теперь опредеяем имя файла и URL. Для читаемости...
NR_FILE_NAME="$NR_PATH/Nuerburgring Log $(date '+%Y-%m-%d %H-%M-%S').jpg"
NR_URL="http://www.nuerburgring.de/fileadmin/webcam/webcam.jpg"

# Юзерагент...
# http://stackoverflow.com/questions/5189913/pick-and-print-one-of-three-strings-at-random-in-bash-script
PREDEFINED_UA[0]="Mozilla/5.0 (Windows NT 5.1; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29.1"
PREDEFINED_UA[1]="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"
PREDEFINED_UA[2]="Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)"
PREDEFINED_UA[3]="Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko"
PREDEFINED_UA[4]="Opera/9.80 (Windows NT 6.2; WOW64) Presto/2.12.388 Version/12.17"
PREDEFINED_UA[5]="Mozilla/5.0 (Windows NT 6.3; WOW64; rv:30.0) Gecko/20100101 Firefox/30.0"
PREDEFINED_UA[6]="Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"

# Выбираем случайное значение из массива...
RND=$(( $RANDOM % 7 ))
UA="${PREDEFINED_UA[$RND]}"

# Качаем!
wget "$NR_URL" -O "$NR_FILE_NAME" --user-agent="$UA" --progress=dot --no-verbose
