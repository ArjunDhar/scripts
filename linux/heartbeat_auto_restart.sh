#!/bin/sh

# Script by Ajrun Dhar to check if a Server page is up or not, if not it sends email to intended admin recipient
# Usage : sh heartbeat.sh http://wrap.co.in/home.html backup@neurosys.biz
# sh /home/stylyts/heartbeat_auto_restart.sh http://stylyts.biz/forms/login backup@neurosys.biz


result=`curl -s --head $1 | head -n 1`
echo $result
#Replace word and compare if words still match. If replacing the string results in same string then it does not contain the string on the right ... all SUCCESS cases are checked AND's. If none work, then FAIL
if [ "${result#*'200 OK'}" == "$result" -a "${result#*'302 Moved Temporarily'}" == "$result" -a "${result#*'301 Moved Permanently'}" == "$result" -a "${result#*'302 Found'}" == "$result" ]; then
  MESSAGE="":
  echo -e "Server Web Page  $1 is down.\nReporting time : $(date)" > $MESSAGE
  #mail -s "$1 DOWN" "$2" < $MESSAGE
  #echo "Mail sent to $2 reporting downtime"

  sh /home/stylyts/tomcat/bin/shutdown.sh
  pkill -9 java
  sh /home/stylyts/tomcat/bin/startup.sh
  #Wait 2 Minute before testing server again
  sleep 2m
  echo -e "\nServer was started and has response after restart = `curl -s --head $1 | head -n 1`" >> $MESSAGE
  mail -s "$1 AUTO RESTARTED" "$2" < $MESSAGE
  echo "Mail sent to $2 reporting downtime and restart"
else
  echo "Server Page $2 is up"
fi
