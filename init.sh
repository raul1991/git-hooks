#!/bin/bash
#env variables
REPOGITDIR=$(git rev-parse --git-dir 2> /dev/null)
GIT_DIR=".git"
GIT_HOOKS_DIR=$(which init.sh | awk '{split($0,arr,"/init.sh"); print arr[1]};');
DEBUG=$1
bool_glob=false
backup_dir="backup"
scripts_dir="scripts"
hooks_dir="hooks"
existing_hooks=[]
proj_name="git-hooks"

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
          echo $@ &> /dev/null
  else
          echo $@
  fi
}

function start_script
{
  echo "Do you want to install the following hook ?(y/n)"
  read choice

  if [[ $choice == "y" || $choice == "Y" || $choice == "Yes" ]]; then
     echo "Installing..."
     check_dir $REPOGITDIR/$scripts_dir
     if !( $bool_glob ); then
         mkdir $REPOGITDIR/$scripts_dir
     fi

     cp -R $GIT_HOOKS_DIR/$scripts_dir/* $REPOGITDIR/$scripts_dir/

     echo "Scripts copied..."

     cp -R $GIT_HOOKS_DIR/$hooks_dir/* $REPOGITDIR/$hooks_dir/

     echo "Hooks copied"

  fi
}

function search_existing_hooks
{
   _noOfHooks=$(ls "$REPOGITDIR/$hooks_dir/" --ignore='*.sample' | wc -l)
   if [ $_noOfHooks == 0 ];then
       echo "No installed hook found"
   else
       list=$(ls "$REPOGITDIR/$hooks_dir/" --ignore='*.sample') #ignoring the sample files
       exiting_hooks="applypatch-msg prepare-commit-msg commit-msg pre-push post-update pre-rebase pre-applypatch pre-receive pre-commit.new update pre-commit"
     found_hooks=();
       for hook in $exiting_hooks
       do
           for sample in $list
           do
             if [ $hook == $sample ]; then
                   log "Found the following hook $hook"
                   echo "Do you want to replace this hook ? (y/n)"
                   read choice

                   if [[ $choice == "y" || $choice == "Y" || $choice == "Yes" ]]; then
                        found_hooks[$i]=$hook
                      ((i++))

                   fi
           fi
         done
       done
       backup_exiting_hooks
   fi
}

function backup_exiting_hooks
{
   check_dir "$REPOGITDIR/$backup_dir"
   log "Checking if backup exists or not in $REPOGITDIR/ True/False ? => " $bool_glob
   if !( $bool_glob ); then
       echo "Creating the backup dir"
       mkdir $REPOGITDIR/$backup_dir
   fi
   for hook in ${found_hooks[@]}

   do
       cp "$GIT_HOOKS_DIR/$hooks_dir/$hook" "$REPOGITDIR/$backup_dir/$hook"
       echo "Backing up $hook hook."
       ((i++))
   done

}

#Calling the script
search_existing_hooks
start_script
