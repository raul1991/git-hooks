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

if [ "$whiteSpaceErrors" = 0 ]; then
   clear
   echo "Everything is fine"
   exit 0
else
   echo "Remove the whitespace errors"
   exit 1		
fi
