#!/bin/bash

function process_share_1() {
#$1 = SHARE_NAME
  re=0
  if [ $1 == "transactions" ]; then
    app=payment
  else
    app=frontend_node
  fi

  share=`grep "$2/$app/data/integration/$1" /etc/fstab`
#  echo $share
  SHARE_PATH=`echo $share | awk '{print $2;}'`
  if [ ! -z "$share" ]; then
	#это бинд или нет?
    remote_share=`echo $share | awk '{print $1;}'`
    share_bind_subdir=""
    new_share=""
    share_remote=`echo $share | awk '{print $1;}'`
    echo "$share" | grep "bind" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
	#если да: определим SHARE_BIND_ROOT, SHARE_BIND_SUBDIR
      new_share=`cat /etc/fstab | awk '{print $2;}' | grep $remote_share`
      until [ ! -z "$new_share" ]; do
	tempdir=`basename "$remote_share"`
        share_bind_subdir="$tempdir/${share_bind_subdir}"
        remote_share=`dirname "$remote_share"`
        new_share=`cat /etc/fstab | awk '{print $2;}' | grep $remote_share`
      done
      share_remote=`cat /etc/fstab | grep $remote_share | awk '{print $1;}' | grep -v $remote_share`
    else
      remote_share=""
    fi
#    echo "f1(): SHARE_BIND_ROOT = $remote_share; SHARE_BIND_SUBDIR = $share_bind_subdir, SHARE_REMOTE = $share_remote, SHARE_PATH=$SHARE_PATH, SHARE_NAME=`basename $SHARE_PATH`"
    echo "$FUNCNAME"
    echo -e "\t{";
    echo -e "\t\t\"{#SHARE_NAME}\":\"`basename $2`-`basename $SHARE_PATH`\",";
    echo -e "\t\t\"{#SHARE_MUST_MOUNTED}\":\"1\",";
    echo -e "\t\t\"{#SHARE_PATH}\":\"$SHARE_PATH\",";
    echo -e "\t\t\"{#SHARE_BIND_ROOT}\":\"$remote_share\",";
    echo -e "\t\t\"{#SHARE_BIND_SUBDIR}\":\"$share_bind_subdir\",";
    echo -e "\t\t\"{#SHARE_REMOTE}\":\"$share_remote\"";
    echo -e "\t}";
  else
    re=1
  fi
  return $re;
}

function process_share_2() {
    re=0
    app=$1
    share=`grep "$2/$app/data/integration" /etc/fstab`
    if [ ! -z "$share" ]; then
#check bind for non-direct mount
    share_remote=`echo $share | awk '{print $1;}'`
    share_path=`echo $share | awk '{print $2;}'`
    remote_share=""; share_bind_subdir="";
#      echo "f2(): SHARE_BIND_ROOT = $remote_share; SHARE_BIND_SUBDIR = $share_bind_subdir, SHARE_REMOTE = $share_remote, SHARE_PATH=$share_path, SHARE_NAME=`basename $share_path`"
    echo "$FUNCNAME"
    echo -e "\t{";
    echo -e "\t\t\"{#SHARE_NAME}\":\"`basename $2`-`basename $share_path`\",";
    echo -e "\t\t\"{#SHARE_MUST_MOUNTED}\":\"1\",";
    echo -e "\t\t\"{#SHARE_PATH}\":\"$share_path\",";
    echo -e "\t\t\"{#SHARE_BIND_ROOT}\":\"$remote_share\",";
    echo -e "\t\t\"{#SHARE_BIND_SUBDIR}\":\"$share_bind_subdir\",";
    echo -e "\t\t\"{#SHARE_REMOTE}\":\"$share_remote\"";
    echo -e "\t}";
    else
      re=1
    fi
  return $re;
}

echo -e "{";
echo -e "\t\"data\":[\n";
echo -e "\t";

for user in `ls -d /var/www/*parking`; do
  if [ -d $user ]; then
    process_share_1 "reservations" "$user"; a=$?;
    process_share_1 "fines" "$user"; b=$?;
    process_share_1 "parkingFacts" "$user"; c=$?;
    process_share_1 "monitoringParkomats" "$user"; d=$?;
    process_share_1 "transactions" "$user"; e=$?;

    not_conn_buf=""
    if [ $a -eq 1 ]; then
#      temp="$user/frontend_node/data/integration/{reservations} not connected\n"
      temp="\t{\n\t\t\"{#SHARE_NAME}\":\"$user-reservations\",\n\t\t\"{#SHARE_MUST_MOUNTED}\":\"0\",\n\t\t\"{#SHARE_PATH}\":\"$user/frontend_node/data/integration/reservations\",\n";
      not_conn_buf="$not_conn_buf$temp"
    fi

    if [ $b -eq 1 ]; then
#      temp="$user/frontend_node/data/integration/{fines} not connected\n"
      temp="\t{\n\t\t\"{#SHARE_NAME}\":\"$user-fines\",\n\t\t\"{#SHARE_MUST_MOUNTED}\":\"0\",\n\t\t\"{#SHARE_PATH}\":\"$user/frontend_node/data/integration/fines\",\n";
      not_conn_buf="$not_conn_buf$temp"
    fi

    if [ $c -eq 1 ]; then
#      temp="$user/frontend_node/data/integration/{parkingFacts} not connected\n"
      temp="\t{\n\t\t\"{#SHARE_NAME}\":\"$user-parkingFacts\",\n\t\t\"{#SHARE_MUST_MOUNTED}\":\"0\",\n\t\t\"{#SHARE_PATH}\":\"$user/frontend_node/data/integration/parkingFacts\",\n";
      not_conn_buf="$not_conn_buf$temp"
    fi

    if [ $d -eq 1 ]; then
#      temp="$user/frontend_node/data/integration/{monitoringParkomats} not connected\n"
      temp="\t{\n\t\t\"{#SHARE_NAME}\":\"$user-monitoringParkomats\",\n\t\t\"{#SHARE_MUST_MOUNTED}\":\"0\",\n\t\t\"{#SHARE_PATH}\":\"$user/frontend_node/data/integration/monitoringParkomats\",\n";
      not_conn_buf="$not_conn_buf$temp"
    fi

    if [ $a -eq 1 ] && [ $b -eq 1 ] && [ $c -eq 1 ] && [ $d -eq 1 ]; then
      process_share_2 "frontend_node" "$user"; k=$?;
      if [ $k -eq 1 ]; then
        SHARE_MUST_MOUNTED="No"
      else
        not_conn_buf=""
      fi
    fi
    echo -e "$not_conn_buf";

    if [ $e -eq 1 ]; then
      process_share_2 "payment" "$user"; l=$?;
      if [ $l -eq 1 ]; then
#        echo "$user/payment/data/integration/{transactions}: not connected"
        echo -e "\t{\n\t\t\"{#SHARE_NAME}\":\"$user-transactions\",\n\t\t\"{#SHARE_MUST_MOUNTED}\":\"0\",\n\t\t\"{#SHARE_PATH}\":\"$user/frontend_node/data/integration/transactions\"\n";
      fi
    fi
  fi
done
