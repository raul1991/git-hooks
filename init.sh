#!/bin/bash
#env variables
export GIT_DIR=".git"

bool_glob=false

scripts_dir="scripts/"
hooks_dir="hooks/"

function check_dir
{
  if [ -d '$GIT_DIR/$scripts_dir' ]; then
	bool_glob=true
  else
	bool_glob=false
  fi

}

function start_script
{
echo "Do you want to install the following hook ?(y/n)"
read choice

if [[ $choice == "y" || $choice == "Y" || $choice == "Yes" ]]; then
   echo "Installing..."
   check_dir
   if ( $bool_glob ); then

      mkdir $GIT_DIR/$scripts_dir
   fi

   cp -R $scripts_dir/* $GIT_DIR/$scripts_dir/

   echo "Scripts copied..."

   cp -R $hooks_dir/* $GIT_DIR/$hooks_dir/

   echo "Hooks copied"

fi
}

start_script
