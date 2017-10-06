#!/bin/bash
#env variables
export GIT_DIR=".git"

DEBUG=$1
bool_glob=false
backup_dir="backup"
scripts_dir="scripts"
hooks_dir="hooks"
existing_hooks=[]

function check_dir
{
  if [ -d $1 ]; then
    bool_glob=true
  else
    bool_glob=false
  fi

}

function log
{
  if [ $DEBUG == 0 ];then
          echo $1 &> /dev/null
  else
          echo $1
  fi
}

function start_script
{
echo "Do you want to install the following hook ?(y/n)"
read choice

if [[ $choice == "y" || $choice == "Y" || $choice == "Yes" ]]; then
   echo "Installing..."
   check_dir $GIT_DIR/$scripts_dir
   if !( $bool_glob ); then

       mkdir $GIT_DIR/$scripts_dir
   fi

   cp -R $scripts_dir/* $GIT_DIR/$scripts_dir/

   echo "Scripts copied..."

   cp -R $hooks_dir/* $GIT_DIR/$hooks_dir/

   echo "Hooks copied"

fi
}

function search_existing_hooks
{

   list=$(ls .git/hooks/ --ignore='*.sample') #ignoring the sample files
   exiting_hooks="applypatch-msg prepare-commit-msg commit-msg pre-push post-update pre-rebase pre-applypatch pre-receive pre-commit.new update pre-commit"
   for hook in $exiting_hooks
   do
       for sample in $list
       do
       ls $GIT_DIR/$hooks_dir/$hook &> /dev/null
           if [ $hook == $sample ]; then
           log "Found the following hook $hook"
           echo "Do you want to replace this hook ? (y/n)"
           read choice

               if [[ $choice == "y" || $choice == "Y" || $choice == "Yes" ]]; then
            exiting_hooks[$i]=$hook
               ((i++))

           fi
       fi
       done
   done
}

function backup_exiting_hooks
{
   check_dir $GIT_DIR/$backup_dir
   log $bool_glob
   if !( $bool_glob ); then
       echo "Creating the backup dir"
       mkdir $GIT_DIR/$backup_dir
   fi
   for hook in ${exiting_hooks[@]}

   do
       cp $hooks_dir/$hook.* $GIT_DIR/$backup_dir/$hook
       echo "Backing up $hook hook."
       ((i++))
   done

}

#Calling the script
search_existing_hooks
backup_exiting_hooks
start_script
