#!/bin/bash
#env variables
: '
MIT License

Copyright (c) 2016 Ingmar Delsink

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'
source './b-log/b-log.sh'
: '
LOG_LEVEL_OFF    : 0
LOG_LEVEL_FATAL  : 100
LOG_LEVEL_ERROR  : 200
LOG_LEVEL_WARN   : 300
LOG_LEVEL_NOTICE : 400
LOG_LEVEL_INFO   : 500
LOG_LEVEL_DEBUG  : 600
LOG_LEVEL_TRACE  : 700
'

B_LOG --log-level -1


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
          NOTICE $@ &> /dev/null
  else
          NOTICE $@
  fi
}

function start_script
{
  echo "Do you want to install the following hook ?(y/n)"
  read choice

  if [[ $choice == "y" || $choice == "Y" || $choice == "Yes" ]]; then
     DEBUG "Installing..."
     check_dir $REPOGITDIR/$scripts_dir
     if !( $bool_glob ); then
         mkdir $REPOGITDIR/$scripts_dir
     fi

     cp -R $GIT_HOOKS_DIR/$scripts_dir/* $REPOGITDIR/$scripts_dir/

     DEBUG "Scripts copied..."

     cp -R $GIT_HOOKS_DIR/$hooks_dir/* $REPOGITDIR/$hooks_dir/

     DEBUG "Hooks copied"

  fi
}

function search_existing_hooks
{
   _noOfHooks=$(ls "$REPOGITDIR/$hooks_dir/" --ignore='*.sample' | wc -l)
   if [ $_noOfHooks == 0 ];then
       DEBUG "No installed hook found"
   else
       list=$(ls "$REPOGITDIR/$hooks_dir/" --ignore='*.sample') #ignoring the sample files
       exiting_hooks="applypatch-msg prepare-commit-msg commit-msg pre-push post-update pre-rebase pre-applypatch pre-receive pre-commit.new update pre-commit"
     found_hooks=();
       for hook in $exiting_hooks
       do
           for sample in $list
           do
             if [ $hook == $sample ]; then
                   NOTICE "Found the following hook $hook"
                   NOTICE "Do you want to replace this hook ? (y/n)"
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
   NOTICE "Checking if backup exists or not in $REPOGITDIR/ True/False ? => " $bool_glob
   if !( $bool_glob ); then
       NOTICE "Creating the backup dir"
       mkdir $REPOGITDIR/$backup_dir
   fi
   for hook in ${found_hooks[@]}

   do
       cp "$GIT_HOOKS_DIR/$hooks_dir/$hook" "$REPOGITDIR/$backup_dir/$hook"
       NOTICE "Backing up $hook hook."
       ((i++))
   done

}

#Calling the script
search_existing_hooks
start_script
