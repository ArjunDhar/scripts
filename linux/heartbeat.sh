#!/bin/sh

# Script by Ajrun Dhar to check if a Server page is up or not, if not it sends email to intended admin recipient
# Usage : sh heartbeat.sh http://wrap.co.in/home.html backup@neurosys.biz
# sh /home/wrap/heartbeat.sh http://wrap.co.in/home.html backup@neurosys.biz


result=`curl -s --head $1 -A "Mozilla/4.0" | head -n 1`
echo $result
#Replace word and compare if words still match. If replacing the string results in same string then it does not contain the string on the right ... all SUCCESS cases are checked AND's. If none work, then FAIL
if [ "${result#*'200 OK'}" == "$result" -a "${result#*'302 Moved Temporarily'}" == "$result" -a "${result#*'301 Moved Permanently'}" == "$result" -a "${result#*'302 Found'}" == "$result" ]; then
  MESSAGE="":
  echo -e "Server Web Page  $1 is down.\nResult was $result\nReporting time : $(date)" > $MESSAGE
  mail -s "$1 DOWN" "$2" < $MESSAGE
  echo "Mail sent to $2 reporting downtime"
else
  echo "Server Page $1 is up"
fi
