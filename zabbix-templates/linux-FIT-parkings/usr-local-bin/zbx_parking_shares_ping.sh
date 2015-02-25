#!/bin/bash

server=$1

#enable debug mode
debug=0

if [[ -z "$server" ]]; then
  echo "error: wrong input value (server)"
  exit 1
fi

fstype=$2

if [[ -z "$fstype" ]]; then
  echo "error: wrong input value (fstype)"
  exit 1
fi

share=$3

if [[ -z "$share" ]]; then
  echo "error: wrong input value (share)"
  exit 1
fi


if [ $fstype == "cifs" ]; then
  fping $server | grep 'is alive' > /dev/null 2>&1
  echo $?
fi

if [ $fstype == "davfs" ]; then
  curl --connect-timeout 4 -k $share > /dev/null 2>&1
  [[ $? = 0 ]] && echo 0 || echo 1
fi

exit 0
