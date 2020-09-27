#!/bin/bash

# Synch folders : User folder is not same as Website folder. So Synch USER uploads with SITE folder

#cd /catalog/original
# find /catalog/original/ -name '*.*' -exec cp '{}' ./ \;

# Clear existing files to be sure and get fresh dump
rm /catalog/original/* -rf
# Copy all files again but maintain date, permissions etc intact. This helps other more time consuming processes to avoid processing old files by looking at the date time 
cp -a /var/zpanel/hostdata/zadmin/client/catalog/* /catalog/original/ -R

echo Synched Files from User folder to site folder