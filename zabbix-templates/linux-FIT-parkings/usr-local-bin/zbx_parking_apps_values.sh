#!/bin/bash

declare r
r=1
app=$1
port=$2
item=$3

if [[ -z "$app" ]]; then
  echo "error: wrong input value (app)"
  exit 1
fi

if [[ -z "$port" ]]; then
  echo "error: wrong input value (port)"
  exit 1
fi

if [[ -z "$item" ]]; then
  echo "error: wrong input value (item)"
  exit 1
fi

case "$item" in
        "alive")
            if [ "$app" == "payment" ]; then
              cmd="curl http://localhost:$port/payment/system/stat --fail > /dev/null 2>&1;";
            else
              cmd="curl http://localhost:$port/system/stat --fail > /dev/null 2>&1;"
            fi
            eval "$cmd";
            if [ "$?" == "0" ]; then
              r=0
            fi
            ;;
        "custom1")
            if [ "$app" == "frontend_node" ]; then
            :
            fi
            ;;
        *)
            echo "error: wrong input value (item)"
            exit 1
esac

echo $r
exit $r
