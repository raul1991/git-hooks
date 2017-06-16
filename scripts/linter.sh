#!/bin/bash

#current dir
cwd=`pwd`

output=$1

#check for white space errors

git diff --check
whiteSpaceErrors=$?

git diff --cached --check
whiteSpaceErrors=$(($whiteSpaceErrors+$?))
echo Count = $whiteSpaceErrors

is_python_installed=$(python --version &> /dev/null)

if [ $? -ne 0 ]; then
   echo "Python is missing. Please install it or use branch hooks-no-dependency"
   exit 1
fi


if [ "$whiteSpaceErrors" = 0 ]; then
   clear
   echo "Everything is fine"
   exit 0
else
   #the cmd that generates a list of file to run the script on
   cmd=`$output | grep -Eo "^([a-zA-Z._/]*/*\.[a-zA-Z]*)|([a-zA-Z._/]*/[a-zA-Z./_]*/*\.[a-zA-Z]*)"`

   #lint every file for spaces and tab spaces.
   for f in $cmd
   do
    #format using the remove whitespaces command
    python scripts/remove_ws.py -f "$f" -c TS TB
    clear
    echo "White spaces removed - Add files again"
    exit 1
   done
fi
