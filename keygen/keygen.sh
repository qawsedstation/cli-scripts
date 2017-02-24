#!/bin/bash
clear
echo -e "CREATE SSH KEY PAIR:\n"
cd ~/.ssh

keyname(){
	read -p "Enter a key name (e.g. 'aws-$USER'): " KEYID
	if [[ $KEYID == "" ]]; then echo "No user specified"; exit 1; fi
}

passphrase(){
	echo ""; read -s -p "Enter a passphrase: " PASSPHRASE
	echo ""; read -s -p "Confirm passphrase: " PASSPHRASE2
	echo ""; if [[ $PASSPHRASE == "" ]]; then echo "No passphrase specified"; exit 1; fi
	echo ""; if [[ $PASSPHRASE2 == "" ]]; then echo "Passphrase not confirmed"; exit 1; fi
	echo ""; if [[ ! $PASSPHRASE == $PASSPHRASE2 ]]; then echo "Passphrase mismatched"; exit 1; fi
}

comment(){
	read -p "Enter a comment (default: '$KEYID@`hostname`'): " COMMENT
	if [[ $COMMENT == "" ]]; then COMMENT="$KEYID@`hostname`"; fi
}

_keygen(){
	ssh-keygen -q -t rsa -f $KEYID -N $PASSPHRASE -C $COMMENT \
		&& echo -e "\nKey location: `pwd`" \
		&& echo -e "Public key ($KEYID.pub): \n" \
		&& cat $KEYID.pub; echo "" \
		&& ls -lah $KEYID*
}

keyname && passphrase && comment && _keygen

cd ; echo -e "\ncwd = `pwd`\n"
