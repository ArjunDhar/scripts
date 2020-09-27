rm $CATALINA_HOME/logs/*
rm /var/log/apache2/*
cat /dev/null > /var/log/syslog
cat /dev/null > /var/log/mail.log
cat /dev/null > /var/log/main.err
cat /dev/null > /var/log/auth.log
cat /dev/null > /var/log/vsftpd
# cat /dev/null > /var/log/apache2/suexec.log

rm /var/log/*.1
rm /var/log/*.2
rm /var/log/*.3
rm /var/log/*.4
rm /var/log/*.5
rm /var/log/*.gz
rm /home/neurosys/logs/*

# Clean virus off
echo Deleting unwanted malicious files
find / -name "Photo.scr" -type f -delete
find / -name "Video.scr" -type f -delete
find / -name "AV.scr" -type f -delete
find / -name "Photo.lnk" -type f -delete
find / -name "Video.lnk" -type f -delete
find / -name "AV.lnk" -type f -delete
find / -name IMG*.exe -type f -delete
find / -name info.zip -type f -delete

chmod 544 /home/neurosys/public_html/* -R

echo DISK CLEAN DONE