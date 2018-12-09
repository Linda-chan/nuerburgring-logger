#!/bin/bash

APP_TITLE="AJPapps - Nuerburgring logger Bash ver."
APP_COPYRIGHT="Линда Кайе 2009-2018. Посвящается Ариэль"

# Получаем аргументы...
if [ "$2" = "" ] ; then
    if [ "$1" = "--help" ] ; then
        echo "$APP_TITLE"
        echo "$APP_COPYRIGHT"
        echo ""
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
UA="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:63.0) Gecko/20100101 Firefox/63.0"

# Качаем!
wget "$NR_URL" -O "$NR_FILE_NAME" --user-agent="$UA" --progress=dot --no-verbose
