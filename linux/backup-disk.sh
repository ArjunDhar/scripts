#!/bin/bash

# Run >  bash backup-disk.sh N
# Arjun Dhar | 27-09-2020


echo "Backup essentials on disk..."

dir[0]=/home/admin
dir[1]=/home/git
dir[2]=/home/mail-man
dir[3]=/home/neurosys
dir[4]=/home/skippo
dir[5]=/home/stumps

dir[6]=/var/www/html
dir[7]=/var/www/git-web

dir[8]=/etc
dir[9]=/usr/lib/git-core

# Uncompressed directories
dir[10]=/downloads

today=$(date +'%d-%m-%Y')
#echo "$today"

target=/backup/server/BAK-$today
mkdir "$target"

interactive=true
if [[ $1 =~ ^[nNfF]{1}$ ]] ;then
        echo "[Non interactive Mode]"
        interactive=false
else
        echo "[Interactive Mode]"
fi


for dir in ${dir[*]}
do
        backup=false
        if [ "$interactive" = false ] ;then
                backup=true
        else
                echo -n "Back up $dir ? (y/n)"
                read answer
                if [ "$answer" != "${answer#[Yy]}" ] ;then
                  backup=true
                fi
        fi

        if [ $backup = true ] ; then
                echo -e  "\n\n[BAKUP] $dir to $target$dir"
                mkdir -p "$target$dir"
                cp $dir/* "$target$dir/" -R
                echo -e "\t[TAR] ..."
                tar -zcf "$target$dir.tar.gz" "$target$dir"
                # if success then delete dir itself
                if [ $? -eq 0 ]; then
                        echo -e "\t[CLEAN] ..."
                        rm "$target$dir" -rf
                fi
        else
                echo "Skipping $dir"
        fi
done                        