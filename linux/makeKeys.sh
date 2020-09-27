#!/bin/sh

ssh-keygen -t dsa
#or you can use ssh-keygen -t rsa


KEY="$HOME/.ssh/id_dsa.pub"

if [ ! -f ~/.ssh/id_dsa.pub ];then
    echo "private key not found at $KEY"
    echo "* please create it with "ssh-keygen -t dsa" *"
    echo "* to login to the remote host without a password, don't give the key you create with ssh-keygen a password! *"
    exit
fi

if [ -z $1 ];then
    echo "Please specify user@host.tld as the first switch to this script"
    exit
fi

echo "Putting your key on $1... "

KEYCODE=`cat $KEY`
ssh -q $1 "mkdir ~/.ssh 2>/dev/null; chmod 700 ~/.ssh; echo "$KEYCODE" >> ~/.ssh/authorized_keys; chmod 644 ~/.ssh/authorized_keys

echo "done!"

Manually:
1. ssh-keygen -t dsa
2. scp ~/.ssh/id_dsa.pub <hostname>:      (hostname example repos-admin.xxxx.org)
3. SSH to <Hostname>
4. cat ~/id_dsa.pub >> ~/.ssh/authorized_keys

Note: This puts the key on the other machine. Its also important to SSH to the other machine to ensure the latest key is added to the ~/.ssh/known_hosts file.
If not sure, clear the known_hosts file and ssh. like ssh <user>@<remote host>