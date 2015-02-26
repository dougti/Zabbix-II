#!/bin/bash

share_path=$1

if [[ -z "$share_path" ]]; then
  echo "error: wrong input value (share_path)"
  exit 1
fi

share_is_mounted=$2

if [[ -z "$share_is_mounted" ]]; then
  echo "error: wrong input value (share_is_mounted)"
  exit 1
fi

share_bind_root=$3
share_bind_subdir=$4
share_remote=$5

if [[ -z "$share_remote" ]]; then
  echo "error: wrong input value (share_remote)"
  exit 1
fi

case $6 in
     "mounted")
          echo "$share_is_mounted";
          ;;
     "writeable")
          echo "$share_path" | grep '{' > /dev/null 2>&1; a=$?;
          echo "$share_path" | grep '}' > /dev/null 2>&1; b=$?;
          if [ $a -eq 0 ] && [ $b -eq 0 ]; then
            share_path=`dirname "$share_path"`;
          fi
          fname="$share_path/test34875743659874654.txt";
          touch $fname > /dev/null 2>&1; ret=$?;
          echo $ret;
          if [ $ret -eq 0 ]; then
            rm $fname;
          fi
          ;;
     "filelist")
          echo "$share_path" | grep '{' > /dev/null 2>&1; a=$?;
          echo "$share_path" | grep '}' > /dev/null 2>&1; b=$?;
          if [ $a -eq 0 ] && [ $b -eq 0 ]; then
            share_path=`dirname "$share_path"`;
          fi
          ls -l "$share_path";
          ;;
     *)
       echo "error: wrong input value (mounted|writeable|filelist)"
       
exit 1
          ;;
esac

exit 0
