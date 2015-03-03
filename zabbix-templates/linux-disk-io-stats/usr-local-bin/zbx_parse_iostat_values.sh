#!/bin/bash

dev=$1

type=$2

#enable debug mode
debug=0

if [[ -z "$dev" ]]; then
  echo "error: wrong input value (device)"
  exit 1
fi

if [[ -z "$type" ]]; then
  echo "error: wrong input value (type)"
  exit 1
fi

columns=`iostat -dmx|egrep -o "^Device.*"`

columnsarray=($columns)

column_id=1

for i in "${columnsarray[@]}"
do
        #echo "column: $i"

        if [[ "$i" = "$type" ]]; then
		break;
        fi
    column_id=$[column_id + 1]
done

id=$
awk_id="$id$column_id"

eval "cat /var/lib/iostat-poller/stats | grep $1 | awk '{ print $awk_id; }'"

exit 0


