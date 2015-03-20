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
            if [ "$app" == "frontend_node" ]; then
              http_status=$(curl -I http://localhost:$port/ 2>&1 | grep HTTP | awk '{print $2;}') > /dev/null 2>&1
              if [ "x$http_status" == "x200" ]; then
                r=0
              fi
            fi
            if [ "$app" == "payment" ]; then
              http_status=$(curl -I http://localhost:$port/payment/system/balance/check/fd1202f92b2b6a743c61095b63058f57 2>&1 | grep HTTP | awk '{print $2;}') > /dev/null 2>&1
              if [ "x$http_status" == "x200" ]; then
                r=0
              fi
            fi
            if [ "$app" == "sensors" ]; then
              retvalue=$(curl -s -X PUT -H "Content-Type: application/json" -d '{"parkingIds": []}' http://localhost:$port/api/1.0/sensors/getparkingspaces) > /dev/null 2>&1
              echo "x$retvalue" | grep spaces > /dev/null 2>&1
              if [ $? -eq 0 ]; then
                r=0
              fi
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
