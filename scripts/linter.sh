#!/bin/bash

#current dir
cwd=`pwd`

output=`git status -s --untracked-files=no | cut -c4-`

#check for white space errors

git diff --check
whiteSpaceErrors=$?

git diff --cached --check
whiteSpaceErrors=$(($whiteSpaceErrors+$?))
echo Count = $whiteSpaceErrors

if [ "$whiteSpaceErrors" = 0 ]; then
   clear
   echo "Everything is fine"
   exit 0
else
   #lint every file for spaces and tab spaces.
   is_python_installed=$(python --version &> /dev/null)

   if [ $? -ne 0 ]; then
          echo "The following files have space issues. $output"
          echo "Note: Python not found hence reported instead of removing it myself."
          echo "Love, Script"
          exit 1
   else
    for f in $output
    do
        #format using the remove whitespaces command
        python .git/scripts/remove_ws.py -f "$f" -c TS TB
    done
    echo "Whitespaces removed. Please add files again"
    exit 1
   fi
fi
