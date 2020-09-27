#!/bin/sh

# 5/18/2012  by Arjun Dhar
# Params : <DB USERNAME> <DATABASES TO BE BACKEDUP> <DUMP PATH NAME> <SCP/Local SOURCE LOCATION> <SCP/Local DEST LOCATION with username etc> <EMAILL ADDRESS(s)>
# Usage : sh <path to backup script>/backup.sh stylyts stylyts_data /home/stylyts/autobackup.sql - - arjun.dhar@yahoo.com,dhar_ar@yahoo.com
# Note: - implies skip param

mysqldump --user=$1 --password=<_____________TO REPLACE WITH PASSWORD_____________> --databases $2 > $3
if [ "$?" = "0" ]; then
 echo "[DONE] Backedup DB $2 @ location $3"
else
 echo "[ERROR] DB Backup failed"
 exit 1
fi

P=4
if [ $# -gt $P ] 
then
  if [ "$4" != "-" ]; then
   #Skip - arguments
   scp -prvB $4 $5 #Assumes password less login 
   if [ "$?" = "0" ]; then 
     echo "[DONE] SCP (Copy) $4 to $5"
   else
     echo "[ERROR] SCP FAILED"
     cp -vr $4 $5
     if [ "$?" = "0" ]; then
	echo "[DONE] Local Copy from $4 to $5"
     else
	echo "[ERROR] Local Copy also failed"
     fi
   fi
  else
   echo "[SKIP] SCP / Copy"
  fi
fi


#PARAMS: <email address> <Message to send> <File to attach> 
email() {
 if [ -z "$1" ]
 then
  echo "[SKIP] No email provided"
 else #if [ "$1" ]
  valhost=$(hostname):$(pwd)
  SUBJECT="Dont reply : Auto Backup from $valhost"
  EMAIL=$1

  if [ "$3" ]; then
    #Zip attachement
    ZIP_ATTACHMENT="/home/stylyts/auto_backup.zip"
    zip -r $ZIP_ATTACHMENT $3
    echo "[DONE] Zipped $3 into $ZIP_ATTACHMENT to prepare for mail attachment"
    (cat $2; uuencode $ZIP_ATTACHMENT "backup_$(date).zip") | mail -s "$SUBJECT" "$EMAIL"
    #mailx -s "$SUBJECT" "$ZIP_ATTACHMENT" "$EMAIL" < $2
    rm -f ZIP_ATTACHMENT
  else
    echo "[INFO] No attachment"
    mail -s "$SUBJECT" "$EMAIL" < $2
  fi
 fi

 if [ "$?" = "0" ]; then
     echo "[DONE] Email sent to $1"
  else
     echo "[ERROR] Email FAILED"
 fi

 #/bin/mail

 return 0
}

P=5
if [ $# -gt $P ]
then
   MESSAGE="/tmp/backupmail.txt"
   echo "This is an automated backup initiated from $valhost" > $MESSAGE
   echo "As part of maintenance your database is backed up every day (For E-Commerce) and every 7 days (for CMS based sites). In addition the host provider also takes backups, but we prefer to rely on ourselves for faster recovery and your complete peace of mind." >> $MESSAGE
   echo -e "\nBackup was performed on $(date) with params : $2, $3, $4, $5, $6 " >> $MESSAGE
   echo -e "\nSystem Params:----------------------" >> $MESSAGE
   echo -e "\nServer VMSTAT :\n $(vmstat)" >> $MESSAGE
   echo -e "\nOverall DISK SPACE (Note: In a shared hosting instance the actual stats will be lower than projected here. Login into CPanel for details):\n $(df -h)" >> $MESSAGE

   email $6 $MESSAGE $3
else
  echo "[SKIP] No email provided so none sent"
fi
#rm -f $3

echo "[END]"
